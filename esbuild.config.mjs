import esbuildSvelte from "esbuild-svelte";
import sveltePreprocess from "svelte-preprocess";

/** @type {import('esbuild').BuildOptions} */
const options = {
    mainFields: ["browser", "module", "main"],
    minify: true,
    treeShaking: true,
    // support Qt 5.14
    target: ["chrome77"],
    plugins: [
        esbuildSvelte({
            preprocess: sveltePreprocess({ scss: {} }),
            // https://github.com/EMH333/esbuild-svelte#css-output
            compilerOptions: { css: true },
        }),
    ],
    loader: {
        ".png": "dataurl",
        ".svg": "text",
    },
};

export { options as default };
