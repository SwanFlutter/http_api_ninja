import 'dart:convert';

import '../controller/http_controller.dart';

/// Generates HTTP client code snippets for multiple languages.
class CodeGenerator {
  static String generate(HttpController controller, String language) {
    switch (language) {
      case 'Dart':
        return _dart(controller);
      case 'JavaScript':
        return _javascript(controller);
      case 'Node.js':
        return _nodeJs(controller);
      case 'Python':
        return _python(controller);
      case 'cURL':
        return _curl(controller);
      case 'Java':
        return _java(controller);
      case 'Go':
        return _go(controller);
      case 'PHP':
        return _php(controller);
      case 'Ruby':
        return _ruby(controller);
      case 'Swift':
        return _swift(controller);
      case 'C#':
        return _csharp(controller);
      case 'C':
        return _c(controller);
      case 'Kotlin':
        return _kotlin(controller);
      case 'Objective-C':
        return _objectiveC(controller);
      case 'Clojure':
        return _clojure(controller);
      case 'OCaml':
        return _ocaml(controller);
      case 'Powershell':
        return _powershell(controller);
      case 'R':
        return _r(controller);
      case 'Shell':
        return _shell(controller);
      case 'HTTP':
        return _httpRaw(controller);
      default:
        return _curl(controller);
    }
  }

  static String _method(HttpController c) => c.httpMethod.value.toUpperCase();

  static String _url(HttpController c) => _escape(c.url.value);

  static String _body(HttpController c) {
    final b = c.getRequestBody().trim();
    return b.isEmpty ? '' : b;
  }

  static bool _hasBody(HttpController c) {
    final m = _method(c);
    return _body(c).isNotEmpty && !{'GET', 'HEAD'}.contains(m);
  }

  static String _escape(String s) =>
      s.replaceAll('\\', r'\\').replaceAll("'", r"\'").replaceAll('\n', r'\n');

  static String _headersJson(HttpController c) =>
      c.headers.isEmpty ? '{}' : jsonEncode(c.headers);

  static String _dart(HttpController c) {
    final body = _body(c);
    final bodyPart = _hasBody(c)
        ? ", body: jsonEncode(${body.startsWith('{') ? body : "'$body'"})"
        : '';
    return '''
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> makeRequest() async {
  final url = Uri.parse('${_url(c)}');
  final headers = ${_headersJson(c)};

  final response = await http.${c.httpMethod.value.toLowerCase()}(
    url,
    headers: headers$bodyPart,
  );

  print(response.statusCode);
  print(response.body);
}
''';
  }

  static String _javascript(HttpController c) {
    final body = _body(c);
    final bodyPart = _hasBody(c) ? ",\n  body: JSON.stringify(${_jsonBodyLiteral(body)})" : '';
    return '''
fetch('${_url(c)}', {
  method: '${_method(c)}',
  headers: ${_headersJson(c)}$bodyPart,
})
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));
''';
  }

  static String _nodeJs(HttpController c) {
    final body = _body(c);
    final bodyPart = _hasBody(c)
        ? '\nconst body = JSON.stringify(${_jsonBodyLiteral(body)});'
        : '';
    final optsBody = _hasBody(c) ? ', body' : '';
    return '''
const https = require('https');
const http = require('http');
$bodyPart

const options = {
  method: '${_method(c)}',
  headers: ${_headersJson(c)}$optsBody,
};

const req = http.request('${_url(c)}', options, (res) => {
  let data = '';
  res.on('data', chunk => data += chunk);
  res.on('end', () => console.log(data));
});

req.on('error', console.error);
${_hasBody(c) ? 'req.write(body);\n' : ''}req.end();
''';
  }

  static String _python(HttpController c) {
    final body = _body(c);
    final bodyPart = _hasBody(c) ? ", json=${_pythonJsonBody(body)}" : '';
    return '''
import requests

url = '${_url(c)}'
headers = ${_headersJson(c)}

response = requests.${c.httpMethod.value.toLowerCase()}(url, headers=headers$bodyPart)

print(response.status_code)
print(response.text)
''';
  }

  static String _curl(HttpController c) {
    final headers = c.headers.entries
        .map((e) => "-H '${_escape(e.key)}: ${_escape(e.value)}'")
        .join(' \\\n  ');
    final body = _body(c);
    final dataPart = _hasBody(c) ? " \\\n  -d '${_escape(body)}'" : '';
    final headersPart = headers.isEmpty ? '' : ' \\\n  $headers';
    return '''
curl -X ${_method(c)} \\
  '${_url(c)}'$headersPart$dataPart
''';
  }

  static String _java(HttpController c) {
    final body = _body(c);
    final bodyBlock = _hasBody(c)
        ? '''
        String jsonBody = ${body.startsWith('{') ? '"$body"' : '"${_escape(body)}"'};
        HttpRequest.BodyPublisher bodyPublisher =
            HttpRequest.BodyPublishers.ofString(jsonBody);
        '''
        : '';
    final sendBody = _hasBody(c) ? 'bodyPublisher' : 'HttpRequest.BodyPublishers.noBody()';
    return '''
import java.net.http.*;
import java.net.URI;

public class ApiRequest {
    public static void main(String[] args) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        $bodyBlock
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("${_url(c)}"))
            .method("${_method(c)}", $sendBody)
            .build();

        HttpResponse<String> response = client.send(
            request, HttpResponse.BodyHandlers.ofString());

        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}
''';
  }

  static String _go(HttpController c) {
    final body = _body(c);
    final bodyPart = _hasBody(c)
        ? '''
    payload := strings.NewReader(`${body.replaceAll('`', '')}`)
    req, err := http.NewRequest("${_method(c)}", url, payload)
'''
        : '''
    req, err := http.NewRequest("${_method(c)}", url, nil)
''';
    return '''
package main

import (
    "fmt"
    "io"
    "net/http"
    "strings"
)

func main() {
    url := "${_url(c)}"
    $bodyPart
    if err != nil {
        panic(err)
    }

    client := &http.Client{}
    resp, err := client.Do(req)
    if err != nil {
        panic(err)
    }
    defer resp.Body.Close()

    body, _ := io.ReadAll(resp.Body)
    fmt.Println(string(body))
}
''';
  }

  static String _php(HttpController c) {
    final body = _body(c);
    final postFields = _hasBody(c)
        ? "curl_setopt(\$ch, CURLOPT_POSTFIELDS, '${_escape(body)}');\n"
        : '';
    return '''
<?php

\$url = '${_url(c)}';
\$ch = curl_init(\$url);
curl_setopt(\$ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt(\$ch, CURLOPT_CUSTOMREQUEST, '${_method(c)}');
$postFields
\$response = curl_exec(\$ch);
curl_close(\$ch);

echo \$response;
?>
''';
  }

  static String _ruby(HttpController c) {
    final m = c.httpMethod.value.toLowerCase();
    final rubyMethod = {
          'get': 'Get',
          'post': 'Post',
          'put': 'Put',
          'delete': 'Delete',
          'patch': 'Patch',
        }[m] ??
        'Get';
    final body = _body(c);
    final bodyPart = _hasBody(c) ? "request.body = '${_escape(body)}'\n" : '';
    return '''
require 'net/http'
require 'uri'

url = URI('${_url(c)}')
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = (url.scheme == 'https')

request = Net::HTTP::$rubyMethod.new(url)
$bodyPart
response = http.request(request)
puts response.body
''';
  }

  static String _swift(HttpController c) {
    final body = _body(c);
    final bodyPart = _hasBody(c)
        ? 'request.httpBody = """$body""".data(using: .utf8)'
        : '';
    return '''
import Foundation

let url = URL(string: "${_url(c)}")!
var request = URLRequest(url: url)
request.httpMethod = "${_method(c)}"
$bodyPart

let task = URLSession.shared.dataTask(with: request) { data, response, error in
    if let data = data {
        print(String(data: data, encoding: .utf8) ?? "")
    }
}
task.resume()
''';
  }

  static String _csharp(HttpController c) {
    final call = _csharpHttpCall(c);
    return '''
using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        using var client = new HttpClient();
        $call
        var result = await response.Content.ReadAsStringAsync();
        Console.WriteLine(result);
    }
}
''';
  }

  static String _csharpHttpCall(HttpController c) {
    final m = _method(c);
    final url = _url(c);
    if (_hasBody(c)) {
      final body = _body(c);
      final method = switch (m) {
        'POST' => 'PostAsync',
        'PUT' => 'PutAsync',
        'PATCH' => 'PatchAsync',
        _ => 'PostAsync',
      };
      return '''
        var content = new StringContent(
            @"$body",
            Encoding.UTF8,
            "application/json");
        var response = await client.$method(new Uri("$url"), content);
''';
    }
    final method = switch (m) {
      'GET' => 'GetAsync',
      'DELETE' => 'DeleteAsync',
      'HEAD' => 'SendAsync',
      _ => 'GetAsync',
    };
    if (m == 'HEAD') {
      return '''
        var request = new HttpRequestMessage(HttpMethod.Head, "$url");
        var response = await client.SendAsync(request);
''';
    }
    return '        var response = await client.$method("$url");\n';
  }

  static String _c(HttpController c) {
    final body = _body(c);
    final postPart = _hasBody(c)
        ? '''
    const char *payload = "${_escape(body)}";
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, payload);
'''
        : '';
    return '''
#include <stdio.h>
#include <curl/curl.h>

int main(void) {
    CURL *curl = curl_easy_init();
    if (!curl) return 1;

    curl_easy_setopt(curl, CURLOPT_URL, "${_url(c)}");
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "${_method(c)}");
$postPart
    CURLcode res = curl_easy_perform(curl);
    curl_easy_cleanup(curl);
    return (int)res;
}
''';
  }

  static String _kotlin(HttpController c) {
    final body = _body(c);
    final bodyPart = _hasBody(c)
        ? '''
        val body = """
$body
        """.trimIndent().toRequestBody("application/json".toMediaType())
        val request = Request.Builder()
            .url("${_url(c)}")
            .${c.httpMethod.value.toLowerCase()}(body)
            .build()
'''
        : '''
        val request = Request.Builder()
            .url("${_url(c)}")
            .${c.httpMethod.value.toLowerCase()}()
            .build()
''';
    return '''
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody

fun main() {
    val client = OkHttpClient()
    $bodyPart
    client.newCall(request).execute().use { response ->
        println(response.body?.string())
    }
}
''';
  }

  static String _objectiveC(HttpController c) {
    final body = _body(c);
    final bodyPart = _hasBody(c)
        ? '[request setHTTPBody:[@"${_escape(body)}" dataUsingEncoding:NSUTF8StringEncoding]];'
        : '';
    return '''
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSURL *url = [NSURL URLWithString:@"${_url(c)}"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"${_method(c)}"];
        $bodyPart

        NSURLSessionDataTask *task = [[NSURLSession sharedSession]
            dataTaskWithRequest:request
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (data) {
                    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                }
            }];
        [task resume];
        [[NSRunLoop mainRunLoop] run];
    }
    return 0;
}
''';
  }

  static String _clojure(HttpController c) {
    final body = _body(c);
    final bodyPart = _hasBody(c)
        ? ':body (json/write-str """${body.replaceAll('"""', '')}""")'
        : '';
    return '''
(require '[clj-http.client :as client]
         '[cheshire.core :as json])

(def response
  (client/request
    {:method :${c.httpMethod.value.toLowerCase()}
     :url "${_url(c)}"
     :headers ${_headersJson(c)}
     $bodyPart}))

(println (:status response))
(println (:body response))
''';
  }

  static String _ocaml(HttpController c) {
    return '''
open Cohttp_lwt_unix
open Cohttp
open Lwt.Infix

let uri = Uri.of_string "${_url(c)}" in
let body = Cohttp_lwt.Body.of_string "" in

let%lwt (response, body) =
  Client.call `${_method(c)}` uri ~headers:(Header.init ()) body
in
let%lwt body_string = Cohttp_lwt.Body.to_string body in
Lwt.return (Response.status response, body_string)
''';
  }

  static String _powershell(HttpController c) {
    final body = _body(c);
    final bodyPart = _hasBody(c)
        ? "-Body '${_escape(body)}' `\n"
        : '';
    return '''
\$headers = @{${c.headers.entries.map((e) => "'${e.key}' = '${_escape(e.value)}'").join('; ')}}

\$response = Invoke-RestMethod `
    -Uri "${_url(c)}" `
    -Method ${_method(c)} `
    -Headers \$headers `
    $bodyPart

\$response | ConvertTo-Json
''';
  }

  static String _r(HttpController c) {
    final body = _body(c);
    final fn = switch (_method(c)) {
      'GET' => 'GET',
      'POST' => 'POST',
      'PUT' => 'PUT',
      'DELETE' => 'DELETE',
      'PATCH' => 'PATCH',
      _ => 'GET',
    };
    final bodyPart = _hasBody(c)
        ? ", body = '${_escape(body)}', encode = 'json'"
        : '';
    final headersPart = c.headers.isEmpty
        ? ''
        : ', add_headers(.headers = c(${c.headers.entries.map((e) => "'${e.key}' = '${_escape(e.value)}'").join(', ')}))';
    return '''
library(httr)

url <- "${_url(c)}"

response <- $fn(url$headersPart$bodyPart)

content(response, "text")
''';
  }

  static String _shell(HttpController c) => _curl(c);

  static String _httpRaw(HttpController c) {
    final headers = c.headers.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('\n');
    final body = _body(c);
    return '''
${_method(c)} ${_url(c)} HTTP/1.1
$headers

$body
''';
  }

  static String _jsonBodyLiteral(String body) {
    if (body.startsWith('{') || body.startsWith('[')) return body;
    return jsonEncode(body);
  }

  static String _pythonJsonBody(String body) {
    if (body.startsWith('{') || body.startsWith('[')) return body;
    return jsonEncode(body);
  }
}
