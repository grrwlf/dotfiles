vim() {
  case "$@" in
    "")   `which vim` . ;;
    *)  `which vim` "$@" ;;
  esac
}
