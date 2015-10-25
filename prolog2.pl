% II.2 - The Assembly Problem

% TODO:

% Output should be something like this:
/*
topleft goes to center
top goes to bottomright
topright goes to bottom
left goes to right
center goes to top
right goes to topleft
bottomleft goes to left
bottom goes to topright
bottomright goes to bottomleft
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
