#!/usr/bin/env bash

API_KEY="af5176ab34ba42b987d7a3301c40f78b" # insert api key here

# first comment is description, second is icon number
weather_icons=(
    # Day
    [100]=  # 晴
    [101]=  # 多云
    [102]=  # 少云
    [103]=  # 晴间多云

    [300]=  # 阵雨
    [301]=  # 强阵雨

    [406]=  # 阵雨夹雪
    [407]=  # 阵雪

    # Night
    [150]=  # 晴
    [151]=  # 多云
    [152]=  # 少云
    [153]=  # 晴间多云

    [350]=  # 阵雨
    [351]=  # 强阵雨

    [456]=  # 阵雨夹雪 
    [457]=  # 阵雪

    # Both
    [104]=  # 阴

    [302]=  # 雷阵雨
    [303]=  # 强雷阵雨
    [304]=  # 雷阵雨伴有冰雹
    [305]=  # 小雨
    [306]=  # 中雨
    [307]=  # 大雨
    [308]=  # 极端降雨
    [309]=  # 毛毛雨/细雨
    [310]=  # 暴雨
    [311]=  # 大暴雨
    [312]=  # 特大暴雨
    [313]=  # 冻雨
    [314]=  # 小到中雨
    [315]=  # 中到大雨
    [316]=  # 大到暴雨
    [317]=  # 暴雨到大暴雨
    [318]=  # 大暴雨到特大暴雨

    [399]=  # 雨
    [400]=  # 小雪
    [401]=  # 中雪
    [402]=  # 大雪
    [403]=  # 暴雪
    [404]=  # 雨夹雪
    [405]=  # 雨雪天气
    [408]=  # 小到中雪
    [409]=  # 中到大雪
    [410]=  # 大到暴雪

    [499]=  # 雪
    [500]=  # 薄雾
    [501]=  # 雾
    [502]=  # 霾
    [503]=  # 扬沙
    [504]=  # 浮尘

    [507]=  # 沙尘暴
    [508]=  # 强沙尘暴
    [509]=  # 浓雾
    [510]=  # 强浓雾
    [511]=  # 中度霾
    [512]=  # 重度霾
    [513]=  # 严重霾
    [514]=  # 大雾
    [515]=  # 特强浓雾

    [800]=  # 新月
    [801]=  # 蛾眉月
    [802]=  # 上弦月
    [803]=  # 盈凸月
    [804]=  # 满月
    [805]=  # 亏凸月
    [806]=  # 下弦月
    [807]=  # 残月

    [900]=  # 热
    [901]=  # 冷
    [999]=  # 未知
)

location=$(LocateMe -f "{LON},{LAT}")
data=$(curl -L -s --compressed "https://devapi.qweather.com/v7/weather/now?location=$location&key=$API_KEY")
condition=$(echo $data | jq -r '.now.icon')
temp=$(echo $data | jq -r '.now.temp')
feelslike=$(echo $data | jq -r '.now.feelslike')
humidity=$(echo $data | jq -r '.now.humidity')

icon=${weather_icons[$condition]}
sketchybar --set weather    icon="$icon" \
                            label="${temp}°C"
