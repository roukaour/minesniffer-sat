import sys
from itertools import product

class Board(object):
	
	def __init__(self, height, width):
		self.height = height
		self.width = width
		self.board = [[None] * width for _ in xrange(height)]
	
	def __getitem__(self, pos):
		i, j = pos
		assert 0 <= i < self.height and 0 <= j < self.width
		return self.board[i][j]
	
	def __setitem__(self, pos, value):
		i, j = pos
		assert 0 <= i < self.height and 0 <= j < self.width and -1 <= value <= 8
		self.board[i][j] = value
	
	def neighbors(self, pos):
		i, j = pos
		assert 0 <= i < self.height and 0 <= j < self.width
		for (di, dj) in product([-1, 0, 1], [-1, 0, 1]):
			ni, nj = i + di, j + dj
			if 0 <= ni < self.height and 0 <= nj < self.width:
				yield self[ni, nj]

def parse_file(filepath):
	# read the layout file to the board array
	with open(filepath, 'r') as fin:
		height, width = (int(t) for t in fin.readline().strip().split())
		board = Board(height, width)
		for i in xrange(height):
			tokens = fin.readline().strip().split(',')
			j in xrange(width):
				board[i, j] = -1 if tokens[j] == 'X' else int(tokens[j])
	return board

def convert2CNF(board, filepath):
	# interpret the number constraints
	fout = open(filepath, 'w')
	# TODO: convert board to CNF and write to fout
	fout.close()

if __name__ == '__main__':
	if len(sys.argv) < 3:
		print 'Layout or output file not specified.'
		exit(-1)
	board = parse_file(sys.argv[1])
	convert2CNF(board, sys.argv[2])
