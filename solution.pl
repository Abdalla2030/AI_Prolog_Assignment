:-['students_courses.pl'].


%%%%%%%%%%%%%%%%%%%%%%%%%task1%%%%%%%%%%%%%%%%%%%%%%%%%

member(X,[X|_]).
member(X,[_|T]) :-
       member(X,T).

studentsInCourse(Course,List) :-
    studentsInCourse(Course,[],List).

studentsInCourse(Course,TempList,List) :-
    student(ID,Course,GPA), 
	not(member([ID,GPA],TempList)), !,
    append([[ID,GPA]],TempList,NewList),
    studentsInCourse(Course, NewList,List).

studentsInCourse(_,List,List).

%%%%%%%%%%%%%%%%%%%%%%%%%task2%%%%%%%%%%%%%%%%%%%%%%%%%

length_of_list([],0).

length_of_list([H|T],N) :-
    length_of_list(T,N1),
    N is N1+1.
    
numStudents(Course,N) :-
    studentsInCourse(Course,List),
    length_of_list(List,N).
	
%%%%%%%%%%%%%%%%%%%%%%%%%task3%%%%%%%%%%%%%%%%%%%%%%%%%

max_of_list([],0).
max_of_list([H|T],MAX):- max_of_list(T,MAX1), H > MAX1,
    MAX is H.
max_of_list([H|T],MAX):- max_of_list(T,MAX1), H =< MAX1,
    MAX is MAX1.

get_students_grades(Student,List) :-
    get_students_grades(Student,[],List).

get_students_grades(Student,TempList,List) :-
    student(Student,_,Grade),
    not(member(Grade,TempList)), !,
    append([Grade],TempList,NewList),
    get_students_grades(Student,NewList,List).

get_students_grades(_,List,List).
   

maxStudentGrade(Student,MAX) :-
    get_students_grades(Student,Grades),
    max_of_list(Grades,MAX).
	

%%%%%%%%%%%%%%%%%%%%%%%%%task4%%%%%%%%%%%%%%%%%%%%%%%%%

convertDigitToText(0, Text):- Text = zero.
convertDigitToText(1, Text):- Text = one.
convertDigitToText(2, Text):- Text = two.
convertDigitToText(3, Text):- Text = three.
convertDigitToText(4, Text):- Text = four.
convertDigitToText(5, Text):- Text = five.
convertDigitToText(6, Text):- Text = six.
convertDigitToText(7, Text):- Text = seven.
convertDigitToText(8, Text):- Text = eight.
convertDigitToText(9, Text):- Text = nine.

gradeInWords(X, Y,GradeList):-
	student(X, Y, Grade),
	splitting(Grade, GradeList, []).
	

splitting(Num, ResultList, TempList):-
	Num > 0,
	N is Num mod 10,
	NewNum is Num // 10,
	convertDigitToText(N, Text),
	append([Text], TempList, NewList),
	splitting(NewNum, ResultList, NewList).

splitting(0, TempList, TempList).

%%%%%%%%%%%%%%%%%%%%%%%%%task5%%%%%%%%%%%%%%%%%%%%%%%%%

remainingCourses(StudentNum,CourseName,CoursesList):-
	remainingCourses(StudentNum,CourseName,CoursesList,[]).
	
	
remainingCourses(StudentNum, CourseName, CoursesList, TempList):-
    CourseName \== firstCourse,
	prerequisite(PreCourse,CourseName),
	(student(StudentNum, PreCourse, Grade), 
	Grade >= 50 -> remainingCourses(StudentNum, firstCourse, CoursesList, TempList);
	append([PreCourse],TempList, NewList), 
	remainingCourses(StudentNum, PreCourse, CoursesList, NewList)).

remainingCourses(StudentNum,firstCourse, TempList, TempList).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%task5%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% another solution %%%%%%%%%%%%%%%%%%%%%%%%

mainPrerequisite(X, Y):-
    prerequisite(X, Y).

mainPrerequisite(X, Y):-
    prerequisite(X, Z),
    mainPrerequisite(Z, Y).

coursesToTarget(X, L):-
    findall(S,mainPrerequisite(S,X),L).