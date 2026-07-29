#include <napi.h>

Napi::String Hello(const Napi::CallbackInfo &info) {
	return Napi::String::New(info.Env(), "Hello from C++!");
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
	exports.Set(Napi::String::New(env, "hello"),
				Napi::Function::New(env, Hello));
	return exports;
}

NODE_API_MODULE(addon, Init)
