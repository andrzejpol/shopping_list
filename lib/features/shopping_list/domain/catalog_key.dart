String catalogKeyFor(String name) {
  return name.trim().toLowerCase().replaceAll('/', '-');
}
