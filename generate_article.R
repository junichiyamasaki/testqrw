library(readr)
library(dplyr)
library(stringr)
library(purrr)

# CSVファイルを読み込む
df <- read_csv("test.csv")


# カテゴリ名から英数字のみを抽出して再構成
df <- df %>%
  mutate(category = map_chr(str_extract_all(カテゴリ, "[A-Za-z0-9]"), ~paste0(.x, collapse = "")))



# カテゴリごとにフォルダ作成
categorynames <-  unique(df$category)
unlink("article", recursive = TRUE)

for (dir_name in categorynames){
unlink(dir_name, recursive = TRUE)

dir.create(dir_name, recursive = TRUE, showWarnings = FALSE)
}

# カテゴリごとに記事作成
categoryfullnames <-  unique(df$カテゴリ)


for (categoryfull in categoryfullnames){
  df_eachcategory <- df %>% filter(カテゴリ==categoryfull)
  dir_name = map_chr(str_extract_all(categoryfull, "[A-Za-z0-9]"), ~paste0(.x, collapse = ""))
  titletext <- paste0("---\ntitle: '",dir_name  %>% str_to_title(),"'\n---\n")
  cat(titletext, file= paste0(dir_name,"/index.qmd"))
  for(i in 1:nrow(df_eachcategory)) {
    row <- df_eachcategory[i,]
    # do stuff with row
    lines <- c(
        paste0("\n# ", row$変数名,"\n"),
        paste0("- 年: ", row$年,"\n"),
        paste0("- 観測単位: ", row$観測単位,"\n"),
        paste0("- リンク: ", row$リンク,"\n"),
        paste0("- メモ: ", row$メモ,"\n")
      )
    cat(lines, sep='',file= paste0(dir_name,"/index.qmd") ,append=TRUE)
    }
}
