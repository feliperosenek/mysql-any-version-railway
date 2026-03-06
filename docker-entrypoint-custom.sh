#!/bin/bash
set -e

# Parse MYSQL_CONFIG and generate custom MySQL configuration
# Modes: low, normal, high
# Custom format: "shortname=value,shortname=value,..."
# Example: MYSQL_CONFIG="low" or MYSQL_CONFIG="ibps=32M,kbs=1M"

generate_config() {
    local config_string="$1"
    local CONFIG_FILE="/etc/mysql/conf.d/env-config.cnf"
    
    echo "[mysqld]" > "$CONFIG_FILE"
    
    # Split by comma and process each pair
    IFS=',' read -ra PAIRS <<< "$config_string"
    for pair in "${PAIRS[@]}"; do
        # Split by = to get key and value
        key="${pair%%=*}"
        value="${pair#*=}"
        
        # Map shortnames to MySQL option names
        case "$key" in
            ibps)  option="innodb_buffer_pool_size" ;;
            kbs)   option="key_buffer_size" ;;
            toc)   option="table_open_cache" ;;
            tcs)   option="thread_cache_size" ;;
            tts)   option="tmp_table_size" ;;
            mhts)  option="max_heap_table_size" ;;
            ilbs)  option="innodb_log_buffer_size" ;;
            mc)    option="max_connections" ;;
            qcs)   option="query_cache_size" ;;
            qct)   option="query_cache_type" ;;
            ifc)   option="innodb_flush_log_at_trx_commit" ;;
            ilfs)  option="innodb_log_file_size" ;;
            sbs)   option="sort_buffer_size" ;;
            rbs)   option="read_buffer_size" ;;
            rrbs)  option="read_rnd_buffer_size" ;;
            jbs)   option="join_buffer_size" ;;
            *)     option="$key" ;;  # Use as-is if not a shortname
        esac
        
        echo "$option=$value" >> "$CONFIG_FILE"
    done
    
    echo "Generated MySQL config:"
    cat "$CONFIG_FILE"
}

# Only apply configuration if MYSQL_CONFIG is set
if [ -n "$MYSQL_CONFIG" ]; then
    case "$MYSQL_CONFIG" in
        low)
            # Low memory mode (~100-200MB idle)
            echo "Applying LOW memory preset..."
            generate_config "ibps=32M,kbs=1M,toc=64,tcs=4,tts=2M,mhts=2M,ilbs=256K,mc=50,sbs=256K,rbs=128K,rrbs=256K,jbs=256K"
            ;;
        normal)
            # Normal/balanced mode (~300-400MB idle)
            echo "Applying NORMAL memory preset..."
            generate_config "ibps=128M,kbs=8M,toc=256,tcs=8,tts=16M,mhts=16M,ilbs=1M,mc=100,sbs=512K,rbs=256K,rrbs=512K,jbs=512K"
            ;;
        high)
            # High performance mode (~500-700MB idle)
            echo "Applying HIGH performance preset..."
            generate_config "ibps=256M,kbs=16M,toc=512,tcs=16,tts=32M,mhts=32M,ilbs=4M,mc=200,sbs=2M,rbs=1M,rrbs=2M,jbs=2M"
            ;;
        *)
            # Custom configuration
            echo "Applying custom configuration..."
            generate_config "$MYSQL_CONFIG"
            ;;
    esac
else
    echo "MYSQL_CONFIG not set, using MySQL defaults."
fi

# Call original MySQL entrypoint
exec docker-entrypoint.sh "$@"
