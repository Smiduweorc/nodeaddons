#!/usr/bin/env bash
#
# Usage: ./release.sh v[X.Y.Z]
#
# Bumps package.json, regenerates CHANGELOG.md, commits, and creates an
# annotated tag whose message is the changelog for the new version.
# Afterwards, push with: git push && git push --tags

set -euo pipefail

if [ -z "${1:-}" ]; then
	echo "Please provide a tag."
	echo "Usage: ./release.sh v[X.Y.Z]"
	exit 1
fi

tag="$1"
version="${tag#v}"

if ! [[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
	echo "Error: tag must be of the form v[X.Y.Z] (got '$tag')."
	exit 1
fi

# Refuse to release from a dirty tree so the version bump is the only change.
if [ -n "$(git status --porcelain)" ]; then
	echo "Error: working tree is not clean. Commit or stash changes first."
	exit 1
fi

if git rev-parse "$tag" >/dev/null 2>&1; then
	echo "Error: tag '$tag' already exists."
	exit 1
fi

echo "Preparing $tag..."

npm version "$version" --no-git-tag-version --allow-same-version >/dev/null
npx git-cliff --config cliff.toml --tag "$tag" --output CHANGELOG.md

git add package.json package-lock.json CHANGELOG.md
git commit -m "chore(release): prepare for $tag"

# The release commit itself is skipped by the cliff.toml commit parsers, so
# --unreleased yields exactly the commits going into this tag.
export GIT_CLIFF_TEMPLATE="\
	{% for group, commits in commits | group_by(attribute=\"group\") %}
	{{ group | upper_first }}\
	{% for commit in commits %}
		- {% if commit.breaking %}(breaking) {% endif %}{{ commit.message | upper_first }} ({{ commit.id | truncate(length=7, end=\"\") }})\
	{% endfor %}
	{% endfor %}"
changelog="$(npx git-cliff --config cliff.toml --unreleased --strip all)"
git tag -a "$tag" -m "Release $tag" -m "$changelog"

echo "Now push the commit and tag: git push && git push --tags"
