export def --wrapped psf [...rest] {
  ^ps aux | rg ...$rest
}

export def --wrapped lsf [...rest] {
  ^ls | rg ...$rest
}
