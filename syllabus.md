- [CS 1622](#cs-1622)
  * [Course Information](#course-information)
  * [Grading](#grading)
  * [Group Work](#group-work)
  * [Excercise Details](#excercise-details)
  * [Deliverable Details](#deliverable-details)
  * [Assignment submission](#assignment-submission)
  * [Programming Language Selection](#programming-language-selection)
  * [Participating in Class](#participating-in-class)
  * [Disability Services Statement](#disability-services-statement)
  * [Academic Integrity Statement](#academic-integrity-statement)
  * [Back to In-Person](#back-to-in-person)

# CS 1622
Introduction to Compiler Design - Fall 2024

## Course Information

**Taught by:** Wonsun Ahn (wahn at pitt dot edu)
  * GitHub username: wonsunahn

**Class Time and Location:**

  * Tue/Thu 1:00 PM - 2:15 PM @ 404 IS Building

**Instructor's Office Hours:**

  * Chat on Microsoft Teams: Mon-Fri 9:00 AM - 6:00 PM
  * Physical Office Hours: Mon 4:30 - 6:00 PM @ 621 IS Building, Fri 2:00 PM - 3:30 PM @ 5423 Sennott Square, or by appointment

**Grading TA Information:**

  * Name: TBD
  * Primary mode of communication: "Regrade Request" on GradeScope
  * Secondary mode of communication: Chat on Microsoft Teams

**Class GitHub repo:** https://www.github.com/wonsunahn/CS1622_Fall2024

**Required Texts:**

Alfred V.Aho, Monica Lam, Ravi Sethi and Jeffery D.Ullman, Compilers: principles, techniques and tools, 2nd Edition, 2006, Addison-Wesley Publishing Company. 

<img alt="Text Book" book.jpg>

## Description

This course takes you through the design and implementation of current
high-level languages. Both frontend and backend issues are dealt with. The
frontend is the part of a compiler that analyzes a pro-gram to produce a form
of internal representation (IR) that is more easily understood by the compiler.
The frontend comprises components such as: lexical analysis, syntax analysis,
and semantic analysis. The backend is the part of a compiler that takes the IR
and produces machine code that can be effi-ciently executed by the processor.
The backend comprises components such as: target code genera-tion, register
allocation, and code optimization. The course also touches upon the management
of storage locations such as processor registers, the program stack, the
program heap and the role of the compiler and language runtime.

## Class Policies

**Exams**:  There will be a midterm and a final. 

**Projects**: There will be four course projects, which will take you through
the implementation of a com-piler for a simple toy programming language called
Mini-Java, starting from the frontend and ending in the backend. The projects
are to be done in C on Linux/Unix environments. The project components are
assigned in roughly increasing order of size and difficulty.  Late submissions
will incur a 5% penalty per day. These are meant to be your own work; anyone
found to be collaborating will be disciplined in accordance to University
policy.  Cheating means (but is not limited to): using code from generative AI,
other universities, your friends, finding it on the Internet, getting help from
unapproved forums, or outsourcing it. 

**Homeworks**: There will be around two written homeworks that are meant to
check your understanding of the course material.

**Participation**:  TopHat attendance will be taken every day.  Both in-class
and out-of-class participation will be taken into consideration.  Please let me
know in advance if you are going to miss a class.

## Grading

* 4 Projects (40%): 10% each
* Exams (40%):
  * Midterm - 20%
  * Final - 20%
* Participation (10%)

Exams will NOT be allowed to be made up except with a valid and verified excuse
(generally medical - others are left to the discretion of the instructor).

The following grading scale will be used.  Note that I generally do _not_ round
grades up.

Score  | Grade
-----: | ------------------------------
100.00-93.00 | A (A+ for extraordinary work)
92.99-90.00  | A-
89.99-87.00  | B+
86.99-83.00  | B
82.99-80.00  | B-
79.99-77.00  | C+
76.99-73.00  | C
72.99-70.00  | C-
69.99-67.00  | D+
66.99-63.00  | D
62.99-60.00  | D-
59.99-0.00   | F

## Assignment submission

All exercises and deliverables will be submitted using GradeScope.

Most assignments will be done in a GitHub Classroom repository.  The repository
will allow you to collaborate effectively with your partner and also keep a
history of all past modifications for versioning purposes.  The repository can
be submitted in its entirety to GradeScope.  Make sure you commit and push your
changes before submitting.  

All exercises are expected to be submitted on time, for the purposes of timely feedback.
Late deliverables will receive a -5 percentage point penalty per day (e.g., if
you would have received a 90% on a deliverable, but you turned it in 3 days
late, you would receive 90 - 15 = 75%.).  

## Programming Language Selection

For all deliverables, the class will use C/C++ with the appropriate frameworks
(Lex/Yacc).  Projects written in other languages or using alternative
frameworks will not be accepted.

## Participating in Class

Questions and comments are invited and strongly encouraged.  If you have a view
point or experience that may enrich the class, please jump in!  There are
several ways you can participate:

1. In-class

    If you are in-person and you have a question, just interrupt me and
interject.  Raising your hand is optional.  

2. Offline

    Please use the Teams "Posts" tab on the "General" channel if you have a
general question or comment.  If you have a question about a specific topic for
which there is a dedicated channel, please use that channel.  For example,
there is currently a "Partner Exchange" channel besides the "General" channel,
so please use that channel to broadcast messages about partners.  Remember, you
are encouraged to answer as well as ask questions!  I will give a thumbs up on
verified answers or I will add a few more things if needed.  

    You can easily DM me or one of your classmates using Teams.  Again, select
the class in the "Teams" menu and then click on the "..." context menu beside
the "CS 1622 Compiler Design" team name.  Please select the top-most
item: "Manage Team".  There, you should be able to see the statuses of all
students in the class, and if you hover over the name of any student, you
should see options to initiate a chat, email, or a call with that individual.

3. Email / Canvas messages

    For the fastest response, please use Teams chat.

When you ask a source-code-specific question about an exercise or deliverable,
please submit your code to GradeScope first so that I can reproduce your error.
Also, describe precisely the steps I should take to reproduce your error.
Before you do this, it is very hard for me to help you.

I will try to get back to all offline communications within 24 hours of
receipt.  Even if I'm logged onto Teams, please understand that I may be away
from my desk or working on something else.  Meanwhile, feel free to answer each
other's questions!

## In-Person Attendance

This is fully in-person class.  I will allow remote participation only in the
following two exceptional circumstances:

_1. If you have a family or medical emergency that would cause you to miss
class.  Rather than miss class, if you are able to participate over Zoom, I
will allow it._

_2. If you have to quarantine due to contact with COVID.  Either you have a
positive test result or you are waiting for test results._

For the above exceptions, I will create Zoom sessions on demand.  These Zoom
sessions are only available to affected students and are protected by a
password which is distributed individually.  Please notify me as soon as you
are affected so I can make arrangements.

## Disability Services Statement

"The Office of Disability Resources and Services (DRS) provides a broad range
of support services to assist students with disabilities. Services include, but
are not limited to, tape-recorded textbooks, sign language interpreters,
adaptive and transportation. Contact DRS at 412-648-7890 or 412-383-1355 (TTY)
in 216 William Pitt Union or see www.drs.pitt.edu for more computer technology,
Braille translation, and nonstandard exam arrangements, DRS can also assist
students with accessibility to campus housing information."

The instructor will work to the best of their ability to accommodate any issues
arising from a disability that a student has, but he must be aware of it in
order to accommodate it.  Please inform me as soon as possible if you have a
disability which you think may hinder your success in the course and we (along
with the DRS) should be able to work around it.

## Academic Integrity Statement

Cheating/plagiarism will _not_ be tolerated. Students suspected of violating
the [SCI Academic Integrity
Policy](https://www.sci.pitt.edu/student-resources/policies/academic-integrity-policy)
will receive a minimum sanction of a zero score for the exam or assignment.

Some guidelines:

_1. For unscored in-class exercises, you are allowed (and encouraged) to look
at your classmates' work and discuss it.  If you get ample help for the
exercises, you should rarely need additional help for the deliverables._

_2. For all scored deliverables and exams, viewing the work done by your
classmates (or a 3rd source) before submission is considered cheating.  Aiding
this activity is also considered cheating.  The only exception is your
designated partner for your group projects._

_3. Text or code generated by generative AI such as ChatGPT or CoPilot is
included in the prohibited 3rd source mentioned above.  You should be the sole
originator of all text or code that you submit as part of this class._
