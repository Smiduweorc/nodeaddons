// Native addons (.node files) cannot be imported as ESM, so load them with createRequire.
import { createRequire } from "module";

const require = createRequire(import.meta.url);

const addon = require("../build/Release/addon") as { hello(): string };

/** Returns the greeting built by the native addon. */
export function hello(): string {
	return addon.hello();
}
