��          �                 5     ~   C  .   �  �   �  �   �  $   F  �   k     �  
     
          B   '  q   j  D   �  �  !  P     �   d  X   b  2  �    �	  E   	  �   O     9     U     g  
   y  �   �  �   &  �   �   API Requests for Gender, Age and Emotions Recognition An exemplary API request for recognizing gender, age and emotions of a person, and the corresponding response are shown below. Configure Gender, Age and Emotions Recognition Enable gender, age and emotions recognition by uncommenting and editing the line ``gae = False`` in the ``findface-facenapi`` configuration file. Restart ``findface-facenapi``. Enable relevant recognition :ref:`models <models>` by uncommenting the ``model_*`` lines in the ``findface-nnapi`` configuration file. Restart ``findface-nnapi``. Gender, Age and Emotions Recognition Gender, age and emotions recognition uses around 2 GB of RAM in addition to the FindFace Server :ref:`general requirements <requirements>`. In this section: Request #1 Request #2 Response The ``findface-facenapi.ini`` content must be correct Python code. To add a face to the database with its gender, age and emotions information, send a POST request to **v1/face**. To configure gender, age and emotions recognition, do the following: Project-Id-Version: FindFace Enterprise Server SDK 2.5
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2017-11-16 13:09+0300
PO-Revision-Date: 2017-11-19 15:05+0300
Last-Translator: Sasha Carlos <info@ntechlab.com>
Language: ru
Language-Team: NtechLab Documentation Team
Plural-Forms: nplurals=3; plural=(n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Generated-By: Babel 2.5.1
 API для распознавания пола, возраста и эмоций Данный запрос обнаруживает лицо на изображении и возвращает координаты рамки вокруг лица вместе с информацией о поле, возрасте и эмоциях. Настройка распознавания пола, возраста и эмоций Включите распознавание пола, возраста и эмоций, раскомментировав и отредактировав строку ``gae = False`` в файле конфигурации ``findface-facenapi``. Перезапустите сервис ``findface-facenapi``. Включите соответствующие :ref:`модели <models>` распознавания, раскомментировав строки ``model_*`` в файле конфигурации ``findface-nnapi``. Перезапустите сервис ``findface-nnapi``. Распознавание пола, возраста и эмоций Для распознавания пола, возраста и эмоций необходимы 2 ГБ оперативной памяти сверх :ref:`общих требований <requirements>` к Серверу FindFace. В этом разделе: Запрос №1 Запрос №2 Ответ Содержимое файла ``findface-facenapi.ini`` должно представлять собой синтаксически верный код Python. Для добавления лица в базу данных вместе с информацией о поле, возрасте и эмоциях, отправьте POST-запрос на адрес ``v1/face``. Для настройки распознавания пола, возраста и эмоций выполните следующие действия: 