# Persistent AutoHotkey v2 Script to Run a Local HTTP Server

import http.server
import socketserver

PORT = 8765

class MacroHandler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode('utf-8')
        response_code = 200
        self.send_response(response_code)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.handle_macro(post_data)

    def handle_macro(self, macro):
        import ahk
        ahk_instance = ahk.AHK()
        tokens = self.parse_macro(macro)
        for token in tokens:
            if token.startswith('{SLEEP '):
                sleep_time = int(token[7:-1])
                ahk_instance.sleep(sleep_time)
            elif token == '{TAB}':
                ahk_instance.send('{TAB}')
            elif token == '{ENTER}':
                ahk_instance.send('{ENTER}')
            elif token == '{BACKSPACE}':
                ahk_instance.send('{BACKSPACE}')
            elif token == '{SPACE}':
                ahk_instance.send('{SPACE}')

    def parse_macro(self, macro):
        tokens = []
        i = 0
        while i < len(macro):
            if macro[i] == '{':
                end_index = macro.find('}', i)
                if end_index != -1:
                    tokens.append(macro[i:end_index + 1])
                    i = end_index + 1
                else:
                    break
            else:
                tokens.append(macro[i])
                i += 1
        return tokens

with socketserver.TCPServer(('', PORT), MacroHandler) as httpd:
    print(f"Serving HTTP on port {PORT}...")
    httpd.serve_forever()