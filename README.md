# Error finder program in C++
This program counts all errors count in file which was redirected to standart input stream (stdin).
Use:
```sh
make
./main < file
```  
Run tests of program:
```sh
make test
```  
or:
```sh
make
./main < test.txt --test
```  

Compare result of program with real count of errors in file:
```sh
make compare
```