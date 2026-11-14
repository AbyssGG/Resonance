/* Resolve variadic OpenVINO entry points using the platform's native ABI. */
#include <stddef.h>

#if defined(_WIN32)
#include <windows.h>
#define NV_LIBRARY "openvino_c.dll"
#define NV_OPEN() LoadLibraryA(NV_LIBRARY)
#define NV_SYMBOL(h, n) GetProcAddress((HMODULE)(h), (n))
#define NV_CLOSE(h) FreeLibrary((HMODULE)(h))
#if defined(__GNUC__) && defined(__x86_64__)
#define NV_ABI __attribute__((ms_abi))
#else
#define NV_ABI
#endif
#else
#include <dlfcn.h>
#if defined(__APPLE__)
#define NV_LIBRARY "libopenvino_c.dylib"
#else
#define NV_LIBRARY "libopenvino_c.so"
#endif
#define NV_OPEN() dlopen(NV_LIBRARY, RTLD_LAZY | RTLD_LOCAL)
#define NV_SYMBOL(h, n) dlsym((h), (n))
#define NV_CLOSE(h) dlclose(h)
#define NV_ABI
#endif

typedef struct ov_core ov_core_t;
typedef struct ov_model ov_model_t;
typedef struct ov_compiled_model ov_compiled_model_t;
typedef int ov_status_e;
typedef ov_status_e (NV_ABI *nv_compile_model_fn)(
    const ov_core_t*, const ov_model_t*, const char*, size_t, ov_compiled_model_t**, ...);
typedef ov_status_e (NV_ABI *nv_set_property_fn)(const ov_compiled_model_t*, ...);

ov_status_e nv_compile_model_with_perf_count(const ov_core_t* core,
    const ov_model_t* model, const char* device_name, ov_compiled_model_t** compiled_model)
{
    void* lib = (void*)NV_OPEN();
    if (!lib) return -1;
    nv_compile_model_fn fn = (nv_compile_model_fn)NV_SYMBOL(lib, "ov_core_compile_model");
    ov_status_e status = fn ? fn(core, model, device_name, 2, compiled_model, "PERF_COUNT", "YES") : -1;
    NV_CLOSE(lib);
    return status;
}

ov_status_e nv_enable_perf_count(ov_compiled_model_t* compiled_model)
{
    void* lib = (void*)NV_OPEN();
    if (!lib) return -1;
    nv_set_property_fn fn = (nv_set_property_fn)NV_SYMBOL(lib, "ov_compiled_model_set_property");
    ov_status_e status = fn ? fn(compiled_model, "PERF_COUNT", "YES") : -1;
    NV_CLOSE(lib);
    return status;
}
