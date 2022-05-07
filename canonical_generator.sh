#!/bin/bash

today="Created: `date +20%y/%m/%d` `date +%T`"

write()
{
	if [ "$2" == "Makefile" ]; then
		begin="#"
		end="#"
	else
		begin="/*"
		end="*/"
	fi
	let "len=73-`expr length "$2"`"
	echo -n "$begin" > $1
	echo -n " ************************************************************************** " >> $1
	echo "$end" >> $1
	echo -n "$begin" >> $1
	echo -n "                                                    ,---.      .\`\`\`\`\`-.     " >> $1
	echo "$end" >> $1
	echo -n "$begin" >> $1
	echo -n "                                                   /,--.|     /   ,-.  \    " >> $1
	echo "$end" >> $1
	echo -n "$begin" >> $1
	echo -n "    ,_   _, _, ,_   _,,  , ___,___,               //_  ||    (___/  |   |   " >> $1
	echo "$end" >> $1
	echo -n "$begin" >> $1
	echo -n "    |_) /  / \,|_) /_,|\ |' | ' |                /_( )_||          .'  /    " >> $1
	echo "$end" >> $1
	echo -n "$begin" >> $1
	echo -n "   '| \'\_'\_/'| \'\_ |'\|  |  _|_,             /(_ o _)|      _.-'_.-'     " >> $1
	echo "$end" >> $1
	echo -n "$begin" >> $1
	echo -n "    '  \`  \`'   '  \`  \`'  \`  ' '                / /(_,_)||_   _/_  .'        " >> $1
	echo "$end" >> $1
	echo -n "$begin" >> $1
	echo -n "                                              /  \`-----' || ( ' )(__..--.   " >> $1
	echo "$end" >> $1
	echo -n "$begin" >> $1
	echo -n "   $today               \`-------|||-'(_{;}_)      |   " >> $1
	echo "$end" >> $1
	echo -n "$begin" >> $1
	echo -n "                                                      '-'   (_,_)-------'   " >> $1
	echo "$end" >> $1
	echo -n "$begin" >> $1
	echo -n "   $2" >> $1
	for (( i=0; i<$len; i++))
	do echo -n " " >> $1
	done
	echo "$end" >> $1
	echo -n "$begin" >> $1
	echo -n " ************************************************************************** " >> $1
	echo "$end" >> $1
	echo "" >> $1
}

canonCpp()
{
	echo "#include <iostream>" >> $1
	echo "#include \"$2.hpp\"" >> $1
	echo "" >> $1
	echo "$2::$2(void) {" >> $1
	echo "}" >> $1
	echo "" >> $1
	echo "$2::$2($2 const & src) {" >> $1
	echo "        *this = src;" >> $1
	echo "        return ;" >> $1
	echo "}" >> $1
	echo "" >> $1
	echo "$2::~$2(void) {" >> $1
	echo "}" >> $1
	echo "" >> $1
	echo "int     $2::getFoo(void) const {" >> $1
	echo "        return this->_foo;" >> $1
	echo "}" >> $1
	echo "" >> $1
	echo "$2 &  $2::operator=($2 const & rhs) {" >> $1
	echo "        if (this != &rhs)" >> $1
	echo "                this->_foo = rhs.getFoo();" >> $1
	echo "        return *this;" >> $1
	echo "}" >> $1
}

canonHpp()
{
	echo "#ifndef ${2^^}_HPP" >> $1
	echo "# define ${2^^}_HPP" >> $1
	echo "" >> $1
	echo "# include <iostream>" >> $1
	echo "" >> $1
	echo "class $2 {" >> $1
	echo "public:" >> $1
	echo "        $2(void);" >> $1
	echo "        $2($2 const & src);" >> $1
	echo "        ~$2(void);" >> $1
	echo "        $2 &  operator=($2 const & rhs);" >> $1
	echo "        int     getFoo(void) const;" >> $1
	echo "private:" >> $1
	echo "        int     _foo;" >> $1
	echo "};" >> $1
	echo "" >> $1
	echo "#endif" >> $1
}

if [ -z "$1" ]; then
	echo "Usage : ./generator [-noclass] <name>"
elif [ "$1" == "Makefile" ]; then
	write "Makefile" "Makefile"
elif [ "$1" == "-noclass" ]; then
	write $2 $2
else
	if [ ! -d "srcs" ]; then
		mkdir srcs
	fi
	if [ ! -d "includes" ]; then
		mkdir includes
	fi
	write "srcs/$1.cpp" "$1.cpp"
	canonCpp "srcs/$1.cpp" $1
	write "includes/$1.hpp" "$1.hpp"
	canonHpp "includes/$1.hpp" $1
fi