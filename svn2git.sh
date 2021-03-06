####### CONFIGURATION SECTION #######
export urlSvn=svn://server_address/repository	# svn repository url
export svnUsername=username						# svn username
export svnFolder=~/svn_folder					# svn folder name, used for checkout
export gitFolder=~/git_folder.git				# git folder name, used to create then convereted repository
export authorsFile=~/authors.txt				# file containing a list of author, can be created from script

#remember to configure git parameters
#git config --global user.name
#git config --global user.email

####### --------------------- #######


clear
echo "Remember to install git, subversion and git-svn"
echo "  sudo apt-get install git subversion git-svn"
read -p "Press [Enter] to continue or CTRL+C to stop the script and install them..."
echo 
echo "0. Checkout svn repository"
svn co --username $svnUsername $urlSvn/$nomeRepositorySvn $svnFolder
cd $svnFolder

echo # move to a new line
echo "Would you retrieve a list of all Subversion committers"
read -p "and overwrite $authorsFile? [y/N]" -n 1 -r
echo # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "1. Retrieve a list of all Subversion committers"
	svn log -q | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > $authorsFile
	echo "convert 'jwilkins = jwilkins <jwilkins>' into this 'jwilkins = John Albin Wilkins <johnalbin@example.com>'"
	read -p "Press [Enter] to continue..."
	nano $authorsFile
fi



echo "2. Clone the Subversion repository using git-svn"
git svn clone $urlSvn --no-metadata -A $authorsFile --stdlayout ~/temp


echo "3. Convert svn:ignore properties to .gitignore"
cd ~/temp
git svn show-ignore --id=origin/trunk > .gitignore
git add .gitignore
git commit -m 'Convert svn:ignore properties to .gitignore.'


echo "4. Push repository to a bare git repository"
git init --bare $gitFolder
cd $gitFolder
#git symbolic-ref HEAD refs/heads/trunk
git symbolic-ref HEAD refs/heads/origin/master
cd ~/temp
git remote add bare $gitFolder
git config remote.bare.push 'refs/remotes/*:refs/heads/*'
git push bare


echo "5. Rename 'trunk' branch to 'master'"
cd $gitFolder
git branch -m origin/trunk origin/master


echo "6. Clean up branches and tags"
cd $gitFolder
git for-each-ref --format='%(refname)' refs/heads/tags |
cut -d / -f 4 |
while read ref
do
  git tag "$ref" "refs/heads/tags/$ref";
  git branch -D "tags/$ref";
done

echo "Finish!"
