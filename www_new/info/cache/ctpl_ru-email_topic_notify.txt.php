<?php if (!defined('IN_PHPBB')) exit; ?>Subject: Уведомление об ответе — «<?php echo (isset($this->_rootref['TOPIC_TITLE'])) ? $this->_rootref['TOPIC_TITLE'] : ''; ?>»

Здравствуйте, <?php echo (isset($this->_rootref['USERNAME'])) ? $this->_rootref['USERNAME'] : ''; ?>!

Вы получили это сообщение потому, что следите за темой «<?php echo (isset($this->_rootref['TOPIC_TITLE'])) ? $this->_rootref['TOPIC_TITLE'] : ''; ?>» на конференции «<?php echo (isset($this->_rootref['SITENAME'])) ? $this->_rootref['SITENAME'] : ''; ?>». В этой теме со времени вашего последнего посещения появилось новое сообщение. Вы можете перейти по ссылке, чтобы прочитать поступившие ответы; новые уведомления не будут приходить, пока вы не просмотрите тему.

Если вы хотите просмотреть самое новое сообщение с момента вашего последнего посещения, перейдите по следующей ссылке:
<?php echo (isset($this->_rootref['U_NEWEST_POST'])) ? $this->_rootref['U_NEWEST_POST'] : ''; ?>


Если вы хотите просмотреть всю тему, перейдите по следующей ссылке:
<?php echo (isset($this->_rootref['U_TOPIC'])) ? $this->_rootref['U_TOPIC'] : ''; ?>


Если вы хотите просмотреть форум, перейдите по следующей ссылке:
<?php echo (isset($this->_rootref['U_FORUM'])) ? $this->_rootref['U_FORUM'] : ''; ?>


Если вы больше не хотите следить за темой, то либо щёлкните по находящейся в ней ссылке «Отписаться от темы», либо перейдите по следующей ссылке:

<?php echo (isset($this->_rootref['U_STOP_WATCHING_TOPIC'])) ? $this->_rootref['U_STOP_WATCHING_TOPIC'] : ''; ?>


<?php echo (isset($this->_rootref['EMAIL_SIG'])) ? $this->_rootref['EMAIL_SIG'] : ''; ?>