import sys

def parse_file(filepath):
	# read the layout file to the board array
	with open(filepath, 'r') as fin:
		height, width = (int(t) for t in fin.readline().strip().split())
		board = [[-1 if t == 'X' else int(t)
			for t in line.strip().split(',')] for line in fin]
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
