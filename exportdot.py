#!/usr/bin/env python
# encoding: utf-8

text = ''
with open('ETCHelperSwift/data.txt', 'r') as f:
	text = f.read()

colors = {u'國 1': 'green', u'國 1 高架': 'darkgreen',
		  u'國 3': 'blue', u'國 3 甲': 'darkslateblue',
		  u'國 2': 'red', u'國 4': 'yellow', u'國 5' : 'orange', u'國 6': 'brown',
		  u'國 8': 'purple', u'國 10': 'darkslategray'}

links = []
for line in text.split('\n'):
	if not line.startswith("|") or \
	   line.startswith("| #") or\
	   line.startswith("|--"):
		continue
	components = [x.strip() for x in line.split('|') if len(x.strip())]
	tag, begin, end, distance, price, _ = components
	s = '"%s"->"%s" [label="[%s] %.1fkm NTD %.1f", dir="both", color="%s"];' % (begin, end, tag, float(distance), float(price), colors[tag.decode('utf-8')])
	links.append(s)

s = 'digraph G {\n'
s += '\n'.join(links)
s += '}'
with open('graph.gv', 'w') as f:
	f.write(s)
