"""Size and place the board from herdr's layout JSON (stdin).

  layout.py record <board>          print the board's share of the tab width, if it is a full-height column
  layout.py target <board> <share>  print "<target-pane> <ratio>": split the rightmost full-height pane so
                                    the board gets <share> of the tab width
  layout.py fix <board> <share>     print "<direction> <amount>" for herdr pane resize, or nothing
"""
import json
import sys

MIN, MAX = 0.15, 0.70

lay = json.load(sys.stdin)["result"]["layout"]
cmd, board = sys.argv[1], sys.argv[2]
area = lay["area"]
panes = {p["pane_id"]: p["rect"] for p in lay["panes"]}


def clamp(x, lo, hi):
    return max(lo, min(hi, x))


if cmd == "record":
    r = panes.get(board)
    if r and r["height"] == area["height"] and r["x"] + r["width"] == area["x"] + area["width"]:
        print(round(clamp(r["width"] / area["width"], MIN, MAX), 3))
elif cmd == "target":
    share = float(sys.argv[3])
    right = [(pid, r) for pid, r in panes.items()
             if pid != board and r["x"] + r["width"] == area["x"] + area["width"]]
    if right:
        pid, r = max(right, key=lambda x: x[1]["height"])
        print(pid, round(clamp(1 - share * area["width"] / r["width"], 0.10, 0.90), 3))
elif cmd == "fix":
    share = float(sys.argv[3])
    b = panes.get(board)
    # the board's parent split: the one whose right part is exactly the board
    for s in lay.get("splits", []):
        sr = s["rect"]
        if s["direction"] == "right" and b and sr["x"] + sr["width"] == b["x"] + b["width"] \
                and sr["y"] == b["y"] and sr["height"] == b["height"] and sr["width"] > b["width"]:
            want = clamp(1 - share * area["width"] / sr["width"], 0.10, 0.90)
            delta = round(want - s["ratio"], 3)
            if abs(delta) >= 0.02:
                print("right" if delta > 0 else "left", abs(delta))
            break
