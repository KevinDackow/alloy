open permissions
/*
	Taken from the alloydocs tutorial and modified to conform to 
	the state system I have setup.
*/
// File system objects
abstract sig FSObject { }
sig File, Dir extends FSObject { }

// A FileSystem object
sig FileSystem {
  live: set FSObject,
  root: Dir & live,
  parent: (live - root) ->one (Dir & live),
  contents: Dir -> FSObject
}{
  // live objects are reachable from the root
  live in root.*contents
  // parent is the inverse of contents
  parent = ~contents
}
/*
// Moving doesn't add or delete any file system objects
moveOkay: check {
  all fs, fs': FileSystem, x: FSObject, d:Dir |
    move[fs, fs', x, d] => fs'.live = fs.live
} for 5

// remove removes exactly the specified file or directory
removeOkay: check {
  all fs, fs': FileSystem, x: FSObject |
    remove[fs, fs', x] => fs'.live = fs.live - x
} for 5

// removeAll removes exactly the specified subtree
removeAllOkay: check {
  all fs, fs': FileSystem, d: Dir |
    removeAll[fs, fs', d] => fs'.live = fs.live - d.*(fs.contents)
} for 5

// remove and removeAll has the same effects on files
removeAllSame: check {
  all fs, fs1, fs2: FileSystem, f: File |
    remove[fs, fs1, f] && removeAll[fs, fs2, f] => fs1.live = fs2.live
} for 5
*/
