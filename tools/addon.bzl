load("@rules_pkg//pkg:zip.bzl", "pkg_zip")
load("@bazel_skylib//rules:write_file.bzl", "write_file")

def gen_manifest(name, package):
    """Generate `manifest.json`

    https://addon-docs.ankiweb.net/sharing.html#sharing-outside-ankiweb
    """
    dic = {"name": package, "package": package or name}
    json_str = json.encode_indent(dic, indent = "    ")
    write_file(
        name = name,
        out = "manifest.json",
        content = [json_str],
        newline = "unix",
    )

def pkg_addon(sub_labels, out = None, manifest = None):
    full_pkg = native.package_name()
    pkg = full_pkg.split("/")[-1]

    srcs = []
    for i in sub_labels:
        srcs.append(Label("//" + full_pkg + "/" + i))

    # manifest.json
    if manifest:
        srcs.append(manifest)
    else:
        manifest_label = pkg + "_manifest"
        gen_manifest(manifest_label, pkg)
        srcs.append(manifest_label)

    pkg_zip(
        name = pkg,
        srcs = srcs,
        out = out or pkg + ".ankiaddon",
        visibility = ["//visibility:public"],
    )

# https://github.com/bazelbuild/bazel/issues/3983#issuecomment-368520007
def local_deploy(name = None):
    """NOTE: This is still a WIP."""
    full_pkg = native.package_name()
    pkg = full_pkg.split("/")[-1]

    native.sh_binary(
        name = "local_deploy",
        srcs = ["//tools:local_deploy.sh"],
        args = ["$(location //%s)" % full_pkg],
        data = ["//%s" % full_pkg],
        deps = ["@bazel_tools//tools/bash/runfiles"],
        target_compatible_with = [
            "@platforms//cpu:x86_64",
            "@platforms//os:windows",
        ],
    )
