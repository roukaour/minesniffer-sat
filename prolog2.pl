% II.2 - The Assembly Problem

% TODO:

% Output should be something like this:
/*
topleft goes to center rotated 90
top goes to bottomright rotated 0
topright goes to bottom rotated 180
left goes to right rotated 180
center goes to top rotated 0
right goes to topleft rotated 270
bottomleft goes to left rotated 0
bottom goes to topright rotated 0
bottomright goes to bottomleft rotated 90
*/

% Original positions:
/*
+------+  +------+  +------+
|  -b  |  |  +a  |  |  -c  |
|-a  +c|  |-d  +d|  |-d  +b|
|  +d  |  |  -c  |  |  +d  |
+------+  +------+  +------+

+------+  +------+  +------+
|  -d  |  |  +b  |  |  -a  |
|-b  -c|  |+d  -c|  |+b  -d|
|  +d  |  |  -a  |  |  +c  |
+------+  +------+  +------+

+------+  +------+  +------+
|  -b  |  |  -a  |  |  -b  |
|-a  +c|  |+b  -c|  |-c  +a|
|  +b  |  |  +a  |  |  +d  |
+------+  +------+  +------+
*/
