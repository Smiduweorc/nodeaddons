export default {
	extensionsToTreatAsEsm: [".ts"],
	testMatch: ["<rootDir>/test/**/*.test.ts"],
	// ESM-style relative imports carry a .js suffix that maps back to the .ts source.
	moduleNameMapper: {
		"^(\\.{1,2}/.*)\\.js$": "$1",
	},
	transform: {
		"^.+\\.ts$": ["ts-jest", { useESM: true }],
	},
};
