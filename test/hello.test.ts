import { hello } from "../lib/index.js";

it("returns the greeting from the native addon", () => {
	expect(hello()).toBe("Hello from C++!");
});
