WITH ranked_scores AS (
    SELECT
        student_id,
        subject,
        score,
        exam_date,
        ROW_NUMBER() OVER (PARTITION BY student_id, subject ORDER BY exam_date) AS rn_first,
        ROW_NUMBER() OVER (PARTITION BY student_id, subject ORDER BY exam_date DESC) AS rn_last,
        COUNT(*) OVER (PARTITION BY student_id, subject) AS exam_count
    FROM Scores
)
SELECT
    f.student_id,
    f.subject,
    f.score AS first_score,
    l.score AS latest_score
FROM
    ranked_scores f
JOIN
    ranked_scores l
    ON f.student_id = l.student_id
    AND f.subject = l.subject
WHERE
    f.rn_first = 1
    AND l.rn_last = 1
    AND f.exam_count >= 2
    AND l.score > f.score
ORDER BY
    f.student_id,
    f.subject;


/*
Table: Scores

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| student_id  | int     |
| subject     | varchar |
| score       | int     |
| exam_date   | varchar |
+-------------+---------+
(student_id, subject, exam_date) is the primary key for this table.
Each row contains information about a student's score in a specific subject on a particular exam date. score is between 0 and 100 (inclusive).
Write a solution to find the students who have shown improvement. A student is considered to have shown improvement if they meet both of these conditions:

Have taken exams in the same subject on at least two different dates
Their latest score in that subject is higher than their first score
Return the result table ordered by student_id, subject in ascending order.

The result format is in the following example.

 

Example:

Input:

Scores table:

+------------+----------+-------+------------+
| student_id | subject  | score | exam_date  |
+------------+----------+-------+------------+
| 101        | Math     | 70    | 2023-01-15 |
| 101        | Math     | 85    | 2023-02-15 |
| 101        | Physics  | 65    | 2023-01-15 |
| 101        | Physics  | 60    | 2023-02-15 |
| 102        | Math     | 80    | 2023-01-15 |
| 102        | Math     | 85    | 2023-02-15 |
| 103        | Math     | 90    | 2023-01-15 |
| 104        | Physics  | 75    | 2023-01-15 |
| 104        | Physics  | 85    | 2023-02-15 |
+------------+----------+-------+------------+
Output:

+------------+----------+-------------+--------------+
| student_id | subject  | first_score | latest_score |
+------------+----------+-------------+--------------+
| 101        | Math     | 70          | 85           |
| 102        | Math     | 80          | 85           |
| 104        | Physics  | 75          | 85           |
+------------+----------+-------------+--------------+
Explanation:

Student 101 in Math: Improved from 70 to 85
Student 101 in Physics: No improvement (dropped from 65 to 60)
Student 102 in Math: Improved from 80 to 85
Student 103 in Math: Only one exam, not eligible
Student 104 in Physics: Improved from 75 to 85
Result table is ordered by student_id, subject.
