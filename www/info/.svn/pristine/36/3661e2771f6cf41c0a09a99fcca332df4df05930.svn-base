<?php if (!defined('IN_PHPBB')) exit; if (sizeof($this->_tpldata['draftrow'])) {  ?>
<div class="panel">
	<?php echo (isset($this->_tpldata['DEFINE']['.']['CA_BLOCK2_START'])) ? $this->_tpldata['DEFINE']['.']['CA_BLOCK2_START'] : ''; ?>
    	<h3><?php echo ((isset($this->_rootref['L_LOAD_DRAFT'])) ? $this->_rootref['L_LOAD_DRAFT'] : ((isset($user->lang['LOAD_DRAFT'])) ? $user->lang['LOAD_DRAFT'] : '{ LOAD_DRAFT }')); ?></h3>
	<?php echo (isset($this->_tpldata['DEFINE']['.']['CA_BLOCK2_START2'])) ? $this->_tpldata['DEFINE']['.']['CA_BLOCK2_START2'] : ''; ?>
    	
	<p><?php echo ((isset($this->_rootref['L_LOAD_DRAFT_EXPLAIN'])) ? $this->_rootref['L_LOAD_DRAFT_EXPLAIN'] : ((isset($user->lang['LOAD_DRAFT_EXPLAIN'])) ? $user->lang['LOAD_DRAFT_EXPLAIN'] : '{ LOAD_DRAFT_EXPLAIN }')); ?></p>

	<?php $_draftrow_count = (isset($this->_tpldata['draftrow'])) ? sizeof($this->_tpldata['draftrow']) : 0;if ($_draftrow_count) {for ($_draftrow_i = 0; $_draftrow_i < $_draftrow_count; ++$_draftrow_i){$_draftrow_val = &$this->_tpldata['draftrow'][$_draftrow_i]; ?>
	<p>
		<a href="<?php echo $_draftrow_val['U_INSERT']; ?>" title="<?php echo ((isset($this->_rootref['L_LOAD_DRAFT'])) ? $this->_rootref['L_LOAD_DRAFT'] : ((isset($user->lang['LOAD_DRAFT'])) ? $user->lang['LOAD_DRAFT'] : '{ LOAD_DRAFT }')); ?>" class="topictitle"><?php echo $_draftrow_val['DRAFT_SUBJECT']; ?></a>
		    (<?php if (! $this->_rootref['S_PRIVMSGS']) {  if ($_draftrow_val['S_LINK_TOPIC']) {  echo ((isset($this->_rootref['L_TOPIC'])) ? $this->_rootref['L_TOPIC'] : ((isset($user->lang['TOPIC'])) ? $user->lang['TOPIC'] : '{ TOPIC }')); ?>: <a href="<?php echo $_draftrow_val['U_VIEW']; ?>"><?php echo $_draftrow_val['TITLE']; ?></a>, 
				<?php } else if ($_draftrow_val['S_LINK_FORUM']) {  echo ((isset($this->_rootref['L_FORUM'])) ? $this->_rootref['L_FORUM'] : ((isset($user->lang['FORUM'])) ? $user->lang['FORUM'] : '{ FORUM }')); ?>: <a href="<?php echo $_draftrow_val['U_VIEW']; ?>"><?php echo $_draftrow_val['TITLE']; ?></a>, 
				<?php } else { echo ((isset($this->_rootref['L_NO_TOPIC_FORUM'])) ? $this->_rootref['L_NO_TOPIC_FORUM'] : ((isset($user->lang['NO_TOPIC_FORUM'])) ? $user->lang['NO_TOPIC_FORUM'] : '{ NO_TOPIC_FORUM }')); ?>, 
				<?php } } ?><span class="lowercase"><?php echo ((isset($this->_rootref['L_SAVE_DATE'])) ? $this->_rootref['L_SAVE_DATE'] : ((isset($user->lang['SAVE_DATE'])) ? $user->lang['SAVE_DATE'] : '{ SAVE_DATE }')); ?>:</span> <?php echo $_draftrow_val['DATE']; ?>)
	</p>
	<?php }} ?>

    <?php echo (isset($this->_tpldata['DEFINE']['.']['CA_BLOCK2_END'])) ? $this->_tpldata['DEFINE']['.']['CA_BLOCK2_END'] : ''; ?>
</div>
<?php } ?>