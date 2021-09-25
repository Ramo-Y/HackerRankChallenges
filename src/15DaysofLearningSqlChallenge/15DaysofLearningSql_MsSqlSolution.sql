-- Solution for '15 Days of Learning SQL' (MS SQL)

CREATE TABLE #solution (
	SubmissionDate DATE
	,SubmissionCount INT
	,Id INT
	,HackerName NVARCHAR(MAX)
	);

CREATE TABLE #dailyHackers (Id INT);

DECLARE @startDate DATE = '20160301';
DECLARE @previousDate DATE = @startDate;
DECLARE @currentDate DATE = @startDate;
DECLARE @endDate DATE = '20160315';

WHILE (@currentDate <= @endDate)
BEGIN
	SELECT COUNT(*) AS SubCount
		,hkr.hacker_id AS Id
	INTO #todaysHackers
	FROM Hackers hkr
	INNER JOIN Submissions sbm ON sbm.hacker_id = hkr.hacker_id
	WHERE sbm.submission_date = @currentDate
	GROUP BY hkr.hacker_id;

	IF (@currentDate <> @startDate)
	BEGIN
		DELETE
		FROM #dailyHackers
		WHERE #dailyHackers.Id NOT IN (
				SELECT subm.hacker_id
				FROM Submissions subm
				WHERE subm.submission_date = @previousDate
					AND subm.hacker_id IN (
						SELECT Id
						FROM #todaysHackers
						)
				)
	END
	ELSE
	BEGIN
		INSERT INTO #dailyHackers (Id)
		SELECT Id
		FROM #todaysHackers
	END

	DECLARE @uniqueHackersCount INT;

	SET @uniqueHackersCount = (
			SELECT COUNT(*)
			FROM #dailyHackers
			);

	DECLARE @maxCount INT;

	SET @maxCount = (
			SELECT MAX(SubCount)
			FROM #todaysHackers
			);

	DECLARE @mostSubmissionsId INT;

	SET @mostSubmissionsId = (
			SELECT TOP (1) t.Id
			FROM #todaysHackers t
			WHERE SubCount = @maxCount
			ORDER BY t.Id
			);

	DECLARE @mostSubmissionsName NVARCHAR(MAX);

	SET @mostSubmissionsName = (
			SELECT hac.name
			FROM Hackers hac
			WHERE hac.hacker_id = @mostSubmissionsId
			);

	INSERT INTO #solution (
		SubmissionDate
		,SubmissionCount
		,Id
		,HackerName
		)
	VALUES (
		@currentDate
		,@uniqueHackersCount
		,@mostSubmissionsId
		,@mostSubmissionsName
		);

	SET @previousDate = @currentDate;
	SET @currentDate = DATEADD(day, 1, @currentDate);

	DROP TABLE #todaysHackers;
END

SELECT *
FROM #solution

DROP TABLE #solution

DROP TABLE #dailyHackers
