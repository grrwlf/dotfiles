#!/bin/sh

# Comit exactly one file to the git
my_git1() { (
	F=$1
	if test -z "$F" ; then
		FILES=$(git status --porcelain 2>/dev/null | grep "^ M" | awk '{print $2}')
		if test "$(echo $FILES | wc -w)" = "1" ; then
			F=$FILES
		else
			echo "More than 1 file have changed: $FILES" >&2
			exit 1
		fi
	fi
	if ! git status --porcelain 2>/dev/null | grep -q "^M" ; then
		set -e
		git add $F
		git commit -m "$F: Updated"
		git push github master || git push origin master
	else
		echo "Repo has other changes. Commit them first" >&2
		exit 1
	fi
) }

# Links project to github
my_2gh() { (
	CWD=`pwd`
	PROJ=`basename $CWD`

	set -e

	if git remote -v | grep -q ^github ; then
		git remote set-url github git@github.com:grwlf/${PROJ}.git
	else
		git remote add github git@github.com:grwlf/${PROJ}.git
	fi

	git remote -v
) }

git() {
  local arg=$1 ; shift
	case $arg in
		c1)       my_git1 "$@" ;;
		2gh) 	    my_2gh "$@" ;;
		*)        `which git` $arg "$@" ;;
	esac
}

