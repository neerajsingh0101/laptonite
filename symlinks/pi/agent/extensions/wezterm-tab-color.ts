/**
 * WezTerm Tab Color Extension for Pi
 *
 * Changes WezTerm tab color based on Pi agent state:
 * - Green: Pi is done (agent finished, waiting for input)
 * - Clear: User is interacting with Pi
 *
 * Reuses the same /tmp/claude-wezterm-<pane_id> file convention
 * so the existing WezTerm Lua config handles the tab coloring.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { writeFileSync, unlinkSync } from "node:fs";

const paneId = process.env.WEZTERM_PANE;

function setTabDone() {
  if (!paneId) return;
  try {
    writeFileSync(`/tmp/claude-wezterm-${paneId}`, "done\n");
  } catch {}
}

function clearTabStatus() {
  if (!paneId) return;
  try {
    unlinkSync(`/tmp/claude-wezterm-${paneId}`);
  } catch {}
}

export default function (pi: ExtensionAPI) {
  // Green: Pi finished working
  pi.on("agent_end", async () => {
    setTabDone();
  });

  // Clear: User is sending a new prompt
  pi.on("input", async () => {
    clearTabStatus();
  });

  // Clean up on exit
  pi.on("session_shutdown", async () => {
    clearTabStatus();
  });
}
