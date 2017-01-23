CC=g++
CFLAGS=-c
CPPFLAGS=-std=c++11
OFLAG=-o

CPPUNIT_FLAGS=-I$CPPUNIT_HOME/include -L$CPPUNIT_HOME/lib -lcppunit
PCRE_FLAG=-lpcrecpp

SRC=src
OBJ=obj
TEMP=temp
TEST=test

TESTFILE=testfile
SCRIPTFILE=main.sh
OFILE=main

all: $(OFILE)

$(OFILE): $(OBJ)/main.o $(OBJ)/ErrorFinder.o $(OBJ)/ErrorFinderTest.o
	$(CC) $(OBJ)/main.o $(OBJ)/ErrorFinder.o $(OBJ)/ErrorFinderTest.o $(PCRE_FLAG) $(CPPUNIT_FLAGS) $(CPPFLAGS) $(OFLAG) $(OFILE)

$(OBJ)/main.o: $(SRC)/main.cpp
	$(CC) $(CFLAGS) $(SRC)/main.cpp $(CPPFLAGS) $(OFLAG) $(OBJ)/main.o
	
$(OBJ)/ErrorFinder.o: $(SRC)/ErrorFinder/ErrorFinder.cpp
	$(CC) $(CFLAGS) $(SRC)/ErrorFinder/ErrorFinder.cpp $(CPPFLAGS) $(OFLAG) $(OBJ)/ErrorFinder.o
	
$(OBJ)/ErrorFinderTest.o: $(SRC)/ErrorFinderTest/ErrorFinderTest.cpp
	$(CC) $(CFLAGS) $(SRC)/ErrorFinderTest/ErrorFinderTest.cpp $(CPPFLAGS) $(OFLAG) $(OBJ)/ErrorFinderTest.o
	
.PHONY: test compare

create_testfile: $(OFILE)
	echo "conftest.c:217: error: 'TIOCSTAT' undeclared (first use in this function)" > $(TEST)/$(TESTFILE)
	echo "conftest.c:238: fatal error: 'struct dirent' has no member named 'd_namlen'" >> $(TEST)/$(TESTFILE)
	echo "conftest.c:217: error: (Each undeclared identifier is reported only once" >> $(TEST)/$(TESTFILE)
	echo "conftest.c:217: error: for each function it appears in.)" >> $(TEST)/$(TESTFILE)
	echo "configure: failed program was:" >> $(TEST)/$(TESTFILE)

test: $(OFILE) create_testfile
	./$(OFILE) < $(TEST)/$(TESTFILE) --test

compare: $(OFILE) create_testfile
	./$(OFILE) < $(TEST)/$(TESTFILE) > $(TEMP)/tmp1
	./$(SCRIPTFILE) < $(TEST)/$(TESTFILE) > $(TEMP)/tmp2
	diff $(TEMP)/tmp1 $(TEMP)/tmp2

clean:
	rm -rf main $(OBJ)/*.o $(TEST)/$(TESTFILE) $(TEMP)/*