import sys
from itertools import product, combinations

class Board(object):

	def __init__(self, filepath):
		self.filepath = filepath
		with open(filepath, 'r') as fin:
			self.height, self.width = (int(t) for t in fin.readline().split())
			self.board = [[None] * self.width for _ in xrange(self.height)]
			self.num_vars = 0
			for i in xrange(self.height):
				tokens = fin.readline().strip().split(',')
				for j in xrange(self.width):
					if tokens[j] == 'X':
						self.num_vars += 1
						self[i, j] = -self.num_vars
					else:
						self[i, j] = int(tokens[j])

	def __getitem__(self, pos):
		i, j = pos
		assert 0 <= i < self.height and 0 <= j < self.width
		return abs(self.board[i][j])

	def __setitem__(self, pos, value):
		i, j = pos
		assert 0 <= i < self.height and 0 <= j < self.width
		assert -self.num_vars <= value <= 8
		self.board[i][j] = value

	def positions(self):
		return product(xrange(self.height), xrange(self.width))

	def hints(self):
		for pos in self.positions():
			if not self.is_var(pos):
				yield pos

	def is_var(self, pos):
		i, j = pos
		assert 0 <= i < self.height and 0 <= j < self.width
		return self.board[i][j] < 0

	def neighbors(self, pos):
		i, j = pos
		assert 0 <= i < self.height and 0 <= j < self.width
		for (di, dj) in product([-1, 0, 1], [-1, 0, 1]):
			if not di and not dj: continue
			ni, nj = i + di, j + dj
			if 0 <= ni < self.height and 0 <= nj < self.width:
				yield (ni, nj)

	def neighbor_variables(self, pos):
		return [self[n] for n in self.neighbors(pos) if self.is_var(n)]

def parse_file(filepath):
	# Read the layout file to a Minesniffer board
	return Board(filepath)

def distribute(*conjunctions):
	# Given a disjunction of conjunctions, generate a conjunction of disjunctions
	if not conjunctions:
		yield frozenset([])
	else:
		first = conjunctions[0]
		for term in first:
			for disjunction in distribute(*conjunctions[1:]):
				yield frozenset([term]) | disjunction

def convert2CNF(board, filepath):
	# Prepare the CNF output file (comment with the board file name)
	fout = open(filepath, 'w')
	fout.write('c ' + board.filepath.replace('\n', ' ') + '\n')
	# Derive clauses from each hint on the board
	clauses = set()
	for hint in board.hints():
		num_mines = board[hint]
		vars = board.neighbor_variables(hint)
		# Assign M mines to the K variables (M = num_mines, K = len(vars))
		# Generate all K choose M possible assignments of mines
		assignments = [mines + tuple(-v for v in vars if v not in mines)
			for mines in combinations(vars, num_mines)]
		# A set of assignments is a disjunction of conjunctions, so
		# distribute the disjunctions to get a conjunction of disjunctions
		clauses.update(distribute(*assignments))
	# Write the clauses to the output file
	fout.write('p cnf %d %d\n' % (board.num_vars, len(clauses)))
	for clause in clauses:
		fout.write(' '.join(str(v) for v in clause) + ' 0\n')
	fout.close()

# This function is not used
def convert2CNF_efficient(board, filepath):
	# Prepare the CNF output file (comment with the board file name)
	fout = open(filepath, 'w')
	fout.write('c ' + board.filepath.replace('\n', ' ') + '\n')
	# Derive clauses from each hint on the board
	clauses = set()
	for hint in board.hints():
		num_mines = board[hint]
		vars = board.neighbor_variables(hint)
		# Assign M mines to the K variables (M = num_mines, K = len(vars))
		# In any subset of M+1 variables, one must be safe
		clauses.update(frozenset(-v for v in s) for s in combinations(vars, num_mines + 1))
		# In any subset of K-M+1 variables, one must be a mine
		clauses.update(frozenset(s) for s in combinations(vars, len(vars) - num_mines + 1))
	# Prune clauses which are weaker than others (e.g. A|B|C is weaker than A|B)
	clauses = {c for c in clauses if not any(s for s in clauses if s != c and s.issubset(c))}
	# Write the clauses to the output file
	fout.write('p cnf %d %d\n' % (board.num_vars, len(clauses)))
	for clause in clauses:
		fout.write(' '.join(str(v) for v in clause) + ' 0\n')
	fout.close()

if __name__ == '__main__':
	if len(sys.argv) < 3:
		print 'Layout or output file not specified.'
		exit(-1)
	try:
		board = parse_file(sys.argv[1])
	except:
		print 'Parse Error.'
		exit(-1)
	convert2CNF(board, sys.argv[2])
