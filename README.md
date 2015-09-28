# bash-svn2git
Bash script to automatically convert repository from svn to git

Edit configuration at top of svn2git.sh and then execute
    bash svn2git.sh

### Configuration section
<pre>
	export urlSvn=svn://server_address/repository	# svn repository url
	export svnUsername=username						# svn username
	export svnFolder=~/svn_folder					# svn folder name, used for checkout
	export gitFolder=~/git_folder.git				# git folder name, used to create then convereted repository
	export authorsFile=~/authors.txt				# file containing a list of author, can be created from script
</pre>
