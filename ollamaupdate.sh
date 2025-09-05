#!/bin/bash


models="ollama list | grep -v 'SIZE'"
models="${models} | grep -v 'youken9980/'"
models="${models} | grep -v 'unsloth/'"
# models="${models} | sort -hr"
eval "${models}" | while read line; do
	model="$(echo ${line} | awk '{print $1}')"
	size="$(echo ${line} | awk '{print $3" "$4}')"
	cmd="ollama pull ${model}"
	echo -e "${size}\t${cmd}"
	eval "${cmd}"
	echo ""
done
echo ""
ollama list
