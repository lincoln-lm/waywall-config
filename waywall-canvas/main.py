from collections import deque
import threading
import os
import sys
import subprocess
import json
import time
import platform
from flask import Flask, Response, render_template, request

if getattr(sys, "frozen", False):
    base_dir = os.path.dirname(sys.executable)
else:
    base_dir = os.path.abspath(os.path.dirname(__file__))


class App:
    def __init__(self):
        self.parent_pid = os.getppid()
        self.drawing = True
        self.app = Flask(__name__, template_folder=os.path.join(base_dir, "templates"))
        self.new_message = threading.Condition()
        if platform.system() == "Linux":
            self.monitor_thread = threading.Thread(
                target=self.monitor_parent, daemon=True
            )
            self.monitor_thread.start()
        self.app.route("/", methods=["GET"])(self.page)
        self.app.route("/data")(self.event_stream)
        self.app.route("/message", methods=["POST"])(self.receive_message)
        self.app.run(host="0.0.0.0", port=5003)

    def monitor_parent(self):
        while True:
            try:
                os.kill(self.parent_pid, 0)
            except OSError:
                os._exit(1)
            time.sleep(1)

    def page(self):
        return render_template("index.html")

    def event_stream(self):
        def stream():
            last = None
            while True:
                with self.new_message:
                    while not self.drawing:
                        self.new_message.wait()
                result = subprocess.run(
                    ["hyprctl", "cursorpos", "-j"],
                    capture_output=True,
                    text=True,
                    check=True,
                )
                data = json.loads(result.stdout)
                data["x"] *= 5 / 3
                data["y"] *= 5 / 3
                if data != last:
                    yield f"data: {json.dumps(data)}\n\n"
                    last = data
                time.sleep(0.01)

        return Response(stream(), mimetype="text/event-stream")

    def receive_message(self):
        with self.new_message:
            message = request.args.get("message") or request.form.get("message")
            assert message
            message = json.loads(message)
            self.drawing = not message["cursorGrabbed"]
            self.new_message.notify_all()
        return ""


if __name__ == "__main__":
    app = App()
