how to create the initial database
==================================

	CREATE TABLE access_points (
		id INTEGER PRIMARY KEY,
		address TEXT,
		essid TEXT NOT NULL,
		mode TEXT NOT NULL,
		frequency TEXT NOT NULL,
		channel INTEGER NOT NULL,
		encryptionkey TEXT NOT NULL,
		bitrates TEXT NOT NULL,
		quality INTEGER NOT NULL,
		signalstrength INTEGER NOT NULL,
		extra TEXT,
		ie TEXT,
		groupcipher TEXT,
		pairwisecipher TEXT,
		auth TEXT
	);
