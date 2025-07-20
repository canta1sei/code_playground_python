#!/bin/bash

# 環境変数の設定
export PYTHONPATH=$PYTHONPATH:$(pwd)/src

# 動画IDファイルのパス
VIDEO_IDS_FILE="video_ids.txt"

# ファイルが存在するか確認
if [ ! -f "$VIDEO_IDS_FILE" ]; then
    echo "エラー: $VIDEO_IDS_FILE が見つかりません"
    exit 1
fi

# 動画IDを読み込んで処理
while IFS= read -r video_id
do
    # 空行をスキップ
    if [ -z "$video_id" ]; then
        continue
    fi

    echo "動画ID: $video_id のコメントを取得します..."
    
    # コメント取得スクリプトを実行
    python src/youtube_comment_collector.py "$video_id"
    
    # エラーが発生した場合はスキップ
    if [ $? -ne 0 ]; then
        echo "エラー: 動画ID $video_id の処理中にエラーが発生しました"
        continue
    fi
    
    echo "動画ID: $video_id の処理が完了しました"
    echo "----------------------------------------"
    
    # 1秒待機（API制限を考慮）
    sleep 1
    
done < "$VIDEO_IDS_FILE"

echo "すべての処理が完了しました" 