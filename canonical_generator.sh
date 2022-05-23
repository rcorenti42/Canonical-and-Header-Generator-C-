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

mainCpp()
{
	echo "int	main() {" >> srcs/main.cpp
	echo "	return 0;" >> srcs/main.cpp
	echo "}" >> srcs/main.cpp
}

makeCpp()
{	
	echo "NAME =" >> Makefile
	echo "" >> Makefile
	echo "CC++ = c++" >> Makefile
	echo "" >> Makefile
	echo "C++FLAGS = -Wall -Wextra -Werror -std=c++98 -MMD -I" >> Makefile
	echo "" >> Makefile
	echo "SRCS =" >> Makefile
	echo "" >> Makefile
	echo "INCS =" >> Makefile
	echo "" >> Makefile
	echo "OBJS = \$(addprefix srcs/, \$(SRCS:.cpp=.o))" >> Makefile
	echo "" >> Makefile
	echo "DEPS= \$(OBJS:%.o=%.d)" >> Makefile
	echo "" >> Makefile
	echo "all:		\$(NAME)" >> Makefile
	echo "" >> Makefile
	echo "-include \$(DEPS)" >> Makefile
	echo "" >> Makefile
	echo "\$(NAME):	\$(OBJS) \$(INCS)" >> Makefile
	echo "			\$(CC++) \$(C++FLAGS) \$(INCS) -o \$(NAME) \$(OBJS)" >> Makefile
	echo "" >> Makefile
	echo ".cpp.o:" >> Makefile
	echo "			\$(CC++) \$(C++FLAGS) \$(INCS) -c \$< -o \${<:.cpp=.o}" >> Makefile
	echo "" >> Makefile
	echo "clean:" >> Makefile
	echo "			@rm -f \$(OBJS)" >> Makefile
	echo "			@rm -f \$(DEPS)" >> Makefile
	echo "" >> Makefile
	echo "fclean:		clean" >> Makefile
	echo "			@rm -f \$(NAME)" >> Makefile
	echo "" >> Makefile
	echo "re:			fclean all" >> Makefile
	echo "" >> Makefile
	echo ".PHONY:		all clean fclean re" >> Makefile
}

canonCpp()
{
	echo "#include \"$2.hpp\"" >> $1
	echo "" >> $1
	echo "$2::$2() {" >> $1
	echo "}" >> $1
	echo "" >> $1
	echo "$2::$2($2 const & src) {" >> $1
	echo "	*this = src;" >> $1
	echo "}" >> $1
	echo "" >> $1
	echo "$2::~$2() {" >> $1
	echo "}" >> $1
	echo "" >> $1
	echo "$2 &	$2::operator=($2 const & rhs) {" >> $1
	echo "	//if (this != &rhs)" >> $1
	echo "		//this->_foo = rhs.getFoo();" >> $1
	echo "	return *this;" >> $1
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
	echo "	public:" >> $1
	echo "		$2();" >> $1
	echo "		$2($2 const &);" >> $1
	echo "		~$2();" >> $1
	echo "		$2 &	operator=($2 const &);" >> $1
	echo "};" >> $1
	echo "" >> $1
	echo "#endif" >> $1
}

if [ -z "$1" ]; then
	echo "Usage : ./generator [-noclass] <name>"
elif [ "$1" == "Makefile" ]; then
	write "Makefile" "Makefile"
	makeCpp
elif [ "$1" == "main" ];then
	write "srcs/$1.cpp" "$1.cpp"
	mainCpp
elif [ "$1" == "-header" ]; then
	if [ "$2" == "Makefile" ]; then
		mv Makefile tmp
		write "Makefile" "Makefile"
		cat tmp >> Makefile
		rm tmp
	else
		mv $2 tmp
		write $2 $2
		cat tmp >> $2
		rm tmp
	fi
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