from __future__ import annotations

from aqt import editor, gui_hooks, mw, webview

mw.addonManager.setWebExports(__name__, r".*\.(js|map)")
addon_package = mw.addonManager.addonFromModule(__name__)


def on_webview_will_set_content(
    web_content: webview.WebContent, context: object | None
) -> None:
    if isinstance(context, editor.Editor):
        web_content.js.append(f"/_addons/{addon_package}/web/bundle.js")


gui_hooks.webview_will_set_content.append(on_webview_will_set_content)
