echo "Archive, package, and upload..."
./scripts/archive.sh
./scripts/package.sh
find ~/bld -name "*" > results.txt
find ~/ipa -name "*" >> results.txt
