## Homework 1

### Instructions

 Because the course is part of an educational study, we're going to follow a strict naming convention for assignments in the course. Your assignments should have file names taking the form "DSC495_section_FA22_A#_unityid", where you replace "section" with your section number and # with the assignment number. In this case, the assignment number is 1. Please submit your file as a pdf on moodle.
 
 The homework is worth 10 points and is due September 12, by 5 PM.



### Problems
1. (3 points) Write down the shell code to
 + Change directory to two levels higher. 
 + Recursively copy all files and folders from the present folder to `dir1` 
 +  Copy all PNG files containing `project' in its title from the present folder to dir1
2. (3 points) What do the following commands do? 
 +  `cp dir1/*.pdf dir2`
 + `echo $PWD`
 + `ls -l *.pdf | wc -l`
3. (2 points) Explain the difference between `ls data*.pdf` and `ls data???.pdf`.
4. (2 points) Run this code in your shell and report the output. What is this code snippet doing?
```
mkdir dir1 dir2 dir3
for d in */ ; do
    echo "$d"
done
```

