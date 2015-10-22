import sys
import itertools

class Board(object):

	def __init__(self, filepath, height, width):
		self.filepath = filepath
		self.height = height
		self.width = width
		self.board = [[None] * width for _ in xrange(height)]
		self.vars = {}

	def __getitem__(self, pos):
		i, j = pos
		assert 0 <= i < self.height and 0 <= j < self.width
		return self.board[i][j]

	def __setitem__(self, pos, value):
		i, j = pos
		assert 0 <= i < self.height and 0 <= j < self.width and -1 <= value <= 8
		self.board[i][j] = value

	def positions(self):
		return itertools.product(xrange(self.height), xrange(self.width))

	def neighbors(self, pos):
		i, j = pos
		assert 0 <= i < self.height and 0 <= j < self.width
		for (di, dj) in itertools.product([-1, 0, 1], [-1, 0, 1]):
			ni, nj = i + di, j + dj
			if 0 <= ni < self.height and 0 <= nj < self.width:
				yield (ni, nj)

	def neighbor_variables(self, pos):
		return [self.vars[n] for n in self.neighbors(pos) if self[n] == -1]

	def number_variables(self):
		n = 1
		for (i, pos) in enumerate(self.positions()):
			assert self[pos] is not None
			if self[pos] == -1:
				self.vars[pos] = n
				n += 1

def parse_file(filepath):
	with open(filepath, 'r') as fin:
		height, width = (int(t) for t in fin.readline().strip().split())
		board = Board(filepath, height, width)
		for i in xrange(height):
			tokens = fin.readline().strip().split(',')
			for j in xrange(width):
				board[i, j] = -1 if tokens[j] == 'X' else int(tokens[j])
	board.number_variables()
	return board

def make_conjunctions(unknowns, num_mines):
	all_mines = set(unknowns)
	for mine_cells in itertools.combinations(unknowns, num_mines):
		mine_cells = set(mine_cells)
		safe_cells = {-v for v in all_mines - mine_cells}
		yield list(mine_cells | safe_cells)

def distribute(*conjunctions):
	if not conjunctions:
		yield []
	else:
		first = conjunctions[0]
		for term in first:
			for disjunction in distribute(*conjunctions[1:]):
				yield [term] + disjunction

def convert2CNF(board, filepath):
	# Prepare the CNF output file (comment with the board file name)
	fout = open(filepath, 'w')
	fout.write('c ' + board.filepath.replace('\n', ' ') + '\n')
	# Derive clauses from each number on the board
	clauses = []
	for pos in board.positions():
		num_mines = board[pos]
		if num_mines == -1: continue
		unknowns = board.neighbor_variables(pos)
		assignments = make_conjunctions(unknowns, num_mines)
		clauses.extend(distribute(*assignments))
	# Write the clauses to the output file
	fout.write('p cnf %d %d\n' % (len(board.vars), len(clauses)))
	for clause in clauses:
		fout.write(' '.join(str(v) for v in clause) + ' 0\n')
	fout.close()

def convert2CNF_efficient(board, filepath):
	# Prepare the CNF output file (comment with the board file name)
	fout = open(filepath, 'w')
	fout.write('c ' + board.filepath.replace('\n', ' ') + '\n')
	# Derive clauses from each number on the board
	clauses = set()
	for pos in board.positions():
		num_mines = board[pos]
		if num_mines == -1: continue
		unknowns = [n for n in board.neighbors(pos) if board[n] == -1]
		# pos has M neighboring mines and has K neighboring unknowns
		# (M == num_mines, K = len(unknowns))
		# Exactly M of the K unknowns are mines, and exactly K-M are safe
		# So in any subset of M+1 unknowns, one must be safe
		for safe_subset in combinations(unknowns, num_mines + 1):
			clauses.add(frozenset(-board.vars[p] for p in safe_subset))
		# And in any subset of K-M+1 unknowns, one must be a mine
		for mine_subset in combinations(unknowns, len(unknowns) - num_mines + 1):
			clauses.add(frozenset(board.vars[p] for p in mine_subset))
	# Prune clauses which are weaker than others (e.g. A|B|C is weaker than A|B)
	clauses = {c for c in clauses if not any(s for s in clauses if s != c and s.issubset(c))}
	# Write the clauses to the output file
	fout.write('p cnf %d %d\n' % (len(board.vars), len(clauses)))
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
