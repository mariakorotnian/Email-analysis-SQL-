-- Знаходимо кількість всіх акаунтів, акаунтів, які перевірено, акаунтів, які не відписалися, а також інтервал відправлення та дату створення акаунта з групуванням по країнах:
WITH
 accounts AS (
   SELECT
     sp.country,
     ss.date,
     COUNT(acs.account_id) AS account_cnt,
     ac.send_interval AS send_interval,
     ac.is_verified,
     ac.is_unsubscribed,
     0 AS sent_msg,
     0 AS open_msg,
     0 AS click_msg
   FROM `data-analytics-mate.DA.account` ac
   JOIN `data-analytics-mate.DA.account_session` AS acs
     ON ac.id = acs.account_id
   JOIN `data-analytics-mate.DA.session_params` sp
     ON acs.ga_session_id = sp.ga_session_id
   JOIN `data-analytics-mate.DA.session` ss
     ON sp.ga_session_id = ss.ga_session_id
   GROUP BY
     sp.country, ss.date, send_interval, ac.is_verified, ac.is_unsubscribed
 ),


 -- Знаходимо кількість відправлених, відкритих повідомлень та клікнутих повідомлень за датою їх відправлення  з групуванням по країнах, а також інтервал відправлення верифікацію та статус підписки:
 email_metrics AS (
   SELECT
     sp.country,
     DATE_ADD(ss.date, INTERVAL sent_date DAY) AS date,
     0 AS account_cnt,
     ac.send_interval,
     ac.is_verified,
     ac.is_unsubscribed,
     COUNT(DISTINCT es.id_message) AS sent_msg,
     COUNT(DISTINCT eo.id_message) AS open_msg,
     COUNT(DISTINCT ev.id_message) AS click_msg
   FROM `data-analytics-mate.DA.email_sent` es
   LEFT JOIN `data-analytics-mate.DA.email_open` eo
     ON es.id_message = eo.id_message
   LEFT JOIN `data-analytics-mate.DA.email_visit` ev
     ON es.id_message = ev.id_message
   JOIN `data-analytics-mate.DA.account` ac
     ON es.id_account = ac.id
   JOIN `data-analytics-mate.DA.account_session` acs
     ON ac.id = acs.account_id
   JOIN `data-analytics-mate.DA.session` ss
     ON acs.ga_session_id = ss.ga_session_id
   JOIN `data-analytics-mate.DA.session_params` sp
     ON acs.ga_session_id = sp.ga_session_id
   GROUP BY
     date, sp.country, ac.send_interval, ac.is_verified, ac.is_unsubscribed
 ),


 -- Поєднуємо дані з цих двох таблиць в одну:
 information AS (
   SELECT
     country,
     date,
     account_cnt,
     send_interval,
     is_verified,
     is_unsubscribed,
     sent_msg,
     open_msg,
     click_msg
   FROM accounts
   UNION ALL
   SELECT
     country,
     date,
     account_cnt,
     send_interval,
     is_verified,
     is_unsubscribed,
     sent_msg,
     open_msg,
     click_msg
   FROM email_metrics
 ),


 -- Агрегуємо дані по загальній кількості повідомлень(відправлених, відкритих та клікнутих) та по загальній кількості акаутів:
 agregat AS (
   SELECT
     country,
     date,
     sum(account_cnt) AS account_cnt,
     send_interval,
     is_verified,
     is_unsubscribed,
     sum(sent_msg) AS sent_msg,
     sum(open_msg) AS open_msg,
     sum(click_msg) AS click_msg
   FROM information
   GROUP BY country, date, send_interval, is_verified, is_unsubscribed
 ),


 -- Знаходимо загальну кількість створених підписників по країнам та загальну кількість відправлених листів по країнам:
 total AS (
   SELECT
     country,
     date, account_cnt,
     sum(account_cnt) OVER (PARTITION BY country) AS total_country_account_cnt,
     send_interval,
     is_verified,
     is_unsubscribed, sent_msg,
     sum(sent_msg) OVER (PARTITION BY country) AS total_country_sent_cnt,
     open_msg,
     click_msg
   FROM agregat
 ),


 -- рейтинг країн за кількістю створених підписників, рейтинг країн за кількістю відправлених листів:
 rank_data AS (
   SELECT
     country,
     date, account_cnt,
     total_country_account_cnt,
     DENSE_RANK()
       OVER (ORDER BY total_country_account_cnt DESC)
       AS rank_total_country_account_cnt,
     send_interval,
     is_verified,
     is_unsubscribed, sent_msg, 
     total_country_sent_cnt,
     DENSE_RANK()
       OVER (ORDER BY total_country_sent_cnt DESC)
       AS rank_total_country_sent_cnt,
     open_msg,
     click_msg
   FROM total
 )
-- Виводимо країни по рангу за кількістю створення підписників <=10:
SELECT *
FROM rank_data
WHERE rank_total_country_account_cnt <= 10













https://lookerstudio.google.com/reporting/582b8463-750e-4489-8d10-98a0ba092e1d








