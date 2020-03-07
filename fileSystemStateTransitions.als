open state
open filesystem

// Move x to directory d
pred MoveFile [fs, fs': FileSystem, x: FSObject, d: Dir] {
  (x + d) in fs.live
  fs'.parent = fs.parent - x->(x.(fs.parent)) + x->d
}

// Delete the file or directory x
pred remove [fs, fs': FileSystem, x: FSObject] {
  x in (fs.live - fs.root)
  fs'.root = fs.root
  fs'.parent = fs.parent - x->(x.(fs.parent))
}

// Recursively delete the object x
pred removeAll [fs, fs': FileSystem, x: FSObject] {
  x in (fs.live - fs.root)
  fs'.root = fs.root
  let subtree = x.*(fs.contents) |
      fs'.parent = fs.parent - subtree->(subtree.(fs.parent))
}
