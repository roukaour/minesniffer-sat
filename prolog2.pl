% II.2 - The Assembly Problem

% TODO:

% Output should be something like this:
/*
topleft goes to center rotated 90
top goes to bottomright rotated 0
topright goes to bottom rotated 180
...
*/

% Or maybe like this:
/*
1. [-a, -c, +a, +b]
2. [+b, -a, -b, +c]
3. [-a, -d, +c, +b]
...
*/

% Original positions:
/*
1         2         3
+------+  +------+  +------+
|  -b  |  |  +a  |  |  -c  |
|-a  +c|  |-d  +d|  |-d  +b|
|  +d  |  |  -c  |  |  +d  |
+------+  +------+  +------+
4         5         6
+------+  +------+  +------+
|  -d  |  |  +b  |  |  -a  |
|-b  -c|  |+d  -c|  |+b  -d|
|  +d  |  |  -a  |  |  +c  |
+------+  +------+  +------+
7         8         9
+------+  +------+  +------+
|  -b  |  |  -a  |  |  -b  |
|-a  +c|  |+b  -c|  |-c  +a|
|  +b  |  |  +a  |  |  +d  |
+------+  +------+  +------+
*/
