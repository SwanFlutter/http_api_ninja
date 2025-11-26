import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_view/flutter_code_view.dart';
import 'package:get_x_master/get_x_master.dart';

import '../../controller/http_controller.dart';

class ResponseCodeSnippetTab extends StatelessWidget {
  final HttpController controller;
  final bool isDark;

  const ResponseCodeSnippetTab({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          _buildTopBar(context),
          _buildTabBar(context),
          Expanded(child: _buildTabContent(context)),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 400;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildButton(context, Icons.code, 'Code Snippet'),
                const SizedBox(height: 8),
                _buildButton(context, Icons.auto_awesome, 'Generate Types'),
              ],
            );
          }

          return Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.code, size: 16),
                label: Text('Code Snippet', style: context.textTheme.bodySmall),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: Text('Generate Types', style: context.textTheme.bodySmall),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label, style: context.textTheme.bodySmall),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252526) : Colors.grey[50],
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: const TabBar(
        tabs: [
          Tab(text: 'Code'),
          Tab(text: 'Http'),
          Tab(text: 'Copy'),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    return TabBarView(
      children: [
        _CodeTabContent(controller: controller, isDark: isDark),
        _HttpTabContent(controller: controller, isDark: isDark),
        _CopyTabContent(controller: controller, isDark: isDark),
      ],
    );
  }
}

class _CodeTabContent extends StatelessWidget {
  final HttpController controller;
  final bool isDark;

  const _CodeTabContent({
    required this.controller,
    required this.isDark,
  });

  static const languages = [
    'C', 'Clojure', 'C#', 'cURL', 'Dart', 'Go', 'HTTP', 'Java',
    'JavaScript', 'Kotlin', 'Node.js', 'Objective-C', 'OCaml',
    'PHP', 'Powershell', 'Python', 'R', 'Ruby', 'Shell', 'Swift',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 500;

        if (isNarrow) {
          return _buildCompactLayout(context);
        }
        return _buildWideLayout(context);
      },
    );
  }

  Widget _buildCompactLayout(BuildContext context) {
    return Column(
      children: [
        _buildLanguageDropdown(context),
        Expanded(child: _buildCodeDisplay(context)),
      ],
    );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Obx(() => DropdownButtonFormField<String>(
        value: controller.selectedCodeLanguage.value,
        decoration: InputDecoration(
          labelText: 'Language',
          labelStyle: context.textTheme.labelSmall,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: languages.map((lang) => DropdownMenuItem(
          value: lang,
          child: Text(lang, style: context.textTheme.bodySmall),
        )).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.selectedCodeLanguage.value = value;
          }
        },
      )),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        _buildLanguageList(context),
        Expanded(child: _buildCodeDisplay(context)),
      ],
    );
  }

  Widget _buildLanguageList(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
        border: Border(
          right: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.language, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Language',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final lang = languages[index];
                return Obx(() {
                  final isSelected = controller.selectedCodeLanguage.value == lang;
                  return InkWell(
                    onTap: () => controller.selectedCodeLanguage.value = lang,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? const Color(0xFF37373D) : Colors.grey[200])
                            : Colors.transparent,
                      ),
                      child: Text(
                        lang,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : (isDark ? Colors.grey[300] : Colors.grey[800]),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeDisplay(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  final code = CodeGenerator.generate(
                    controller,
                    controller.selectedCodeLanguage.value,
                  );
                  Clipboard.setData(ClipboardData(text: code));
                  Get.snackbar('Copied', 'Code copied to clipboard');
                },
                icon: const Icon(Icons.copy, size: 16),
                label: Text('Copy', style: context.textTheme.bodySmall),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            final code = CodeGenerator.generate(
              controller,
              controller.selectedCodeLanguage.value,
            );
            final language = _getLanguageForCodeView(controller.selectedCodeLanguage.value);
            
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: FlutterCodeView(
                    source: code,
                    language: language,
                    themeType: isDark ? ThemeType.dracula : ThemeType.github,
                    showLineNumbers: true,
                    fontSize: 13,
                    selectionColor: Colors.blue.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    borderColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    padding: const EdgeInsets.all(12),
                    height: null,
                    width: constraints.maxWidth - 16,
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Languages _getLanguageForCodeView(String lang) {
    switch (lang) {
      case 'Dart':
        return Languages.dart;
      case 'JavaScript':
      case 'Node.js':
        return Languages.javascript;
      case 'Python':
        return Languages.python;
      case 'Java':
        return Languages.java;
      case 'Go':
        return Languages.go;
      case 'PHP':
        return Languages.php;
      case 'Ruby':
        return Languages.ruby;
      case 'Swift':
        return Languages.swift;
      case 'C#':
        return Languages.cs;
      case 'C':
        return Languages.cpp;
      case 'Kotlin':
        return Languages.kotlin;
      case 'Shell':
      case 'cURL':
      case 'Powershell':
        return Languages.bash;
      case 'HTTP':
        return Languages.http;
      default:
        return Languages.plaintext;
    }
  }
}

class _HttpTabContent extends StatelessWidget {
  final HttpController controller;
  final bool isDark;

  const _HttpTabContent({
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final httpRequest = '''
${controller.httpMethod.value} ${controller.url.value} HTTP/1.1
${controller.headers.entries.map((e) => '${e.key}: ${e.value}').join('\n')}

${controller.body.value}
''';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: httpRequest));
                  Get.snackbar('Copied', 'HTTP request copied to clipboard');
                },
                icon: const Icon(Icons.copy, size: 16),
                label: Text('Copy', style: context.textTheme.bodySmall),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: FlutterCodeView(
                  source: httpRequest,
                  language: Languages.http,
                  themeType: isDark ? ThemeType.dracula : ThemeType.github,
                  showLineNumbers: true,
                  fontSize: 13,
                  selectionColor: Colors.blue.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  borderColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  padding: const EdgeInsets.all(12),
                  height: null,
                  width: constraints.maxWidth - 16,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CopyTabContent extends StatelessWidget {
  final HttpController controller;
  final bool isDark;

  const _CopyTabContent({
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCopyOption(context, 'Copy URL', controller.url.value, Icons.link),
        _buildCopyOption(
          context,
          'Copy Headers',
          controller.headers.entries.map((e) => '${e.key}: ${e.value}').join('\n'),
          Icons.http,
        ),
        _buildCopyOption(context, 'Copy Body', controller.body.value, Icons.description),
        if (controller.currentResponse.value != null)
          _buildCopyOption(
            context,
            'Copy Response',
            const JsonEncoder.withIndent('  ').convert(controller.currentResponse.value!.body),
            Icons.code,
          ),
      ],
    );
  }

  Widget _buildCopyOption(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: context.textTheme.bodyMedium),
        subtitle: Text(
          content.isEmpty
              ? 'Empty'
              : '${content.substring(0, content.length > 50 ? 50 : content.length)}...',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelSmall,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.copy, size: 18),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: content));
            Get.snackbar('Copied', '$title copied to clipboard');
          },
        ),
      ),
    );
  }
}

/// Code generator utility class
class CodeGenerator {
  static String generate(HttpController controller, String language) {
    switch (language) {
      case 'Dart':
        return _dart(controller);
      case 'JavaScript':
      case 'Node.js':
        return _javascript(controller);
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
      default:
        return '// Code generation for $language coming soon...';
    }
  }

  static String _dart(HttpController c) => '''
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> makeRequest() async {
  final url = Uri.parse('${c.url.value}');
  
  final response = await http.${c.httpMethod.value.toLowerCase()}(
    url,
    headers: ${c.headers.isEmpty ? '{}' : c.headers.toString()},
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
  }
}
''';

  static String _javascript(HttpController c) => '''
fetch('${c.url.value}', {
  method: '${c.httpMethod.value}',
  headers: ${jsonEncode(c.headers)},
})
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));
''';

  static String _python(HttpController c) => '''
import requests

url = '${c.url.value}'
headers = ${c.headers.isEmpty ? '{}' : c.headers.toString()}

response = requests.${c.httpMethod.value.toLowerCase()}(url, headers=headers)

if response.status_code == 200:
    data = response.json()
    print(data)
''';

  static String _curl(HttpController c) {
    final headers = c.headers.entries.map((e) => "-H '${e.key}: ${e.value}'").join(' ');
    return '''
curl -X ${c.httpMethod.value} \\
  '${c.url.value}' \\
  $headers
''';
  }

  static String _java(HttpController c) => '''
import java.net.http.*;
import java.net.URI;

public class ApiRequest {
    public static void main(String[] args) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("${c.url.value}"))
            .${c.httpMethod.value}()
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        System.out.println(response.body());
    }
}
''';

  static String _go(HttpController c) => '''
package main

import (
    "fmt"
    "net/http"
    "io/ioutil"
)

func main() {
    url := "${c.url.value}"
    
    req, _ := http.NewRequest("${c.httpMethod.value}", url, nil)
    
    client := &http.Client{}
    resp, err := client.Do(req)
    if err != nil {
        panic(err)
    }
    defer resp.Body.Close()
    
    body, _ := ioutil.ReadAll(resp.Body)
    fmt.Println(string(body))
}
''';

  static String _php(HttpController c) => '''
<?php

\$url = '${c.url.value}';

\$ch = curl_init(\$url);
curl_setopt(\$ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt(\$ch, CURLOPT_CUSTOMREQUEST, '${c.httpMethod.value}');

\$response = curl_exec(\$ch);
curl_close(\$ch);

echo \$response;
?>
''';

  static String _ruby(HttpController c) => '''
require 'net/http'
require 'json'

url = URI('${c.url.value}')

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::${c.httpMethod.value.capitalize}.new(url)

response = http.request(request)
puts response.body
''';

  static String _swift(HttpController c) => '''
import Foundation

let url = URL(string: "${c.url.value}")!
var request = URLRequest(url: url)
request.httpMethod = "${c.httpMethod.value}"

let task = URLSession.shared.dataTask(with: request) { data, response, error in
    if let data = data {
        let str = String(data: data, encoding: .utf8)
        print(str ?? "")
    }
}

task.resume()
''';

  static String _csharp(HttpController c) => '''
using System;
using System.Net.Http;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        using var client = new HttpClient();
        
        var response = await client.${c.httpMethod.value == 'GET' ? 'GetAsync' : 'PostAsync'}(
            "${c.url.value}"
        );
        
        var content = await response.Content.ReadAsStringAsync();
        Console.WriteLine(content);
    }
}
''';
}
