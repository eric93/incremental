runtime: runtime.o util.o visits.o generated.o
	clang++ -o runtime runtime.o util.o visits.o generated.o

runtime.o: runtime.cpp util.h visits.h
	clang++ -c runtime.cpp

util.o: util.cpp
	clang++ -c util.cpp

visits.o: visits.cpp util.h generated.h
	clang++ -c visits.cpp

generated.o: generated.cpp generated.h util.h fields.h
	clang++ -c generated.cpp

clean:
	rm runtime runtime.o util.o visits.o generated.o
