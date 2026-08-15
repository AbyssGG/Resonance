/*
 * Thin wrappers around OpenVINO's variadic compile_model / set_property APIs.
 *
 * OpenVINO's C entry points accept property pairs through `...`. On Windows
 * x64 the OpenVINO DLL is built with MSVC, while Nim projects are commonly
 * built with MinGW/TDM-GCC. Variadic calls crossing those ABIs are fragile.
 *
 * We resolve the original symbols with GetProcAddress and expose stable,
 * non-variadic cdecl wrappers that Nim can call safely.
 */

#include <stddef.h>

typedef struct ov_core ov_core_t;
typedef struct ov_model ov_model_t;
typedef struct ov_compiled_model ov_compiled_model_t;
typedef int ov_status_e;

typedef __attribute__((ms_abi)) ov_status_e (*nv_compile_model_fn)(
    const ov_core_t*, const ov_model_t*, const char*, size_t, ...);
typedef __attribute__((ms_abi)) ov_status_e (*nv_set_property_fn)(
    ov_compiled_model_t*, ...);

static nv_compile_model_fn g_compile_model = NULL;
static nv_set_property_fn g_set_property = NULL;
static int g_resolved = 0;

typedef struct HINSTANCE__* HINSTANCE;
__declspec(dllimport) HINSTANCE __stdcall LoadLibraryA(const char*);
__declspec(dllimport) void* __stdcall GetProcAddress(HINSTANCE, const char*);

static int nv_resolve_symbols(void)
{
    if (g_resolved) return 1;
    HINSTANCE mod = LoadLibraryA("openvino_c.dll");
    if (!mod) return 0;
    g_compile_model = (nv_compile_model_fn)GetProcAddress(mod, "ov_core_compile_model");
    g_set_property = (nv_set_property_fn)GetProcAddress(mod, "ov_compiled_model_set_property");
    g_resolved = (g_compile_model != NULL && g_set_property != NULL);
    return g_resolved;
}

__declspec(dllexport) ov_status_e __cdecl nv_compile_model_with_perf_count(
    const ov_core_t* core,
    const ov_model_t* model,
    const char* device_name,
    ov_compiled_model_t** compiled_model)
{
    if (!nv_resolve_symbols() || g_compile_model == NULL) return -1;
    return g_compile_model(core, model, device_name, 2, compiled_model, "PERF_COUNT", "YES");
}

__declspec(dllexport) ov_status_e __cdecl nv_enable_perf_count(
    ov_compiled_model_t* compiled_model)
{
    if (!nv_resolve_symbols() || g_set_property == NULL) return -1;
    return g_set_property(compiled_model, "PERF_COUNT", "YES");
}
