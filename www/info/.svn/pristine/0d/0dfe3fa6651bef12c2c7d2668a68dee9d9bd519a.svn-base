<?php if (!defined('IN_PHPBB')) exit; $this->_tpl_include('ucp_header.html'); if ($this->_rootref['S_DRAFT_LOADED']) {  ?>
	<div class="panel" id="message">
		<?php echo (isset($this->_tpldata['DEFINE']['.']['CA_BLOCK2_START'])) ? $this->_tpldata['DEFINE']['.']['CA_BLOCK2_START'] : ''; ?>
		<h3><?php echo ((isset($this->_rootref['L_INFORMATION'])) ? $this->_rootref['L_INFORMATION'] : ((isset($user->lang['INFORMATION'])) ? $user->lang['INFORMATION'] : '{ INFORMATION }')); ?></h3>
		<?php echo (isset($this->_tpldata['DEFINE']['.']['CA_BLOCK2_START2'])) ? $this->_tpldata['DEFINE']['.']['CA_BLOCK2_START2'] : ''; ?>

		<p><?php echo ((isset($this->_rootref['L_DRAFT_LOADED_PM'])) ? $this->_rootref['L_DRAFT_LOADED_PM'] : ((isset($user->lang['DRAFT_LOADED_PM'])) ? $user->lang['DRAFT_LOADED_PM'] : '{ DRAFT_LOADED_PM }')); ?></p>
		
		<?php echo (isset($this->_tpldata['DEFINE']['.']['CA_BLOCK2_END'])) ? $this->_tpldata['DEFINE']['.']['CA_BLOCK2_END'] : ''; ?>
	</div>
<?php } if ($this->_rootref['S_SHOW_DRAFTS']) {  $this->_tpl_include('drafts.html'); } if ($this->_rootref['S_DISPLAY_PREVIEW']) {  $this->_tpl_include('posting_preview.html'); } ?>


<div class="panel" id="postingbox">
	<?php echo (isset($this->_tpldata['DEFINE']['.']['CA_BLOCK2_START'])) ? $this->_tpldata['DEFINE']['.']['CA_BLOCK2_START'] : ''; ?>
        <h2><?php echo ((isset($this->_rootref['L_TITLE'])) ? $this->_rootref['L_TITLE'] : ((isset($user->lang['TITLE'])) ? $user->lang['TITLE'] : '{ TITLE }')); ?></h2>
	<?php echo (isset($this->_tpldata['DEFINE']['.']['CA_BLOCK2_START2'])) ? $this->_tpldata['DEFINE']['.']['CA_BLOCK2_START2'] : ''; ?>

	<?php $this->_tpldata['DEFINE']['.']['EXTRA_POSTING_OPTIONS'] = 1; $this->_tpl_include('posting_editor.html'); if ($this->_tpldata['DEFINE']['.']['EXTRA_POSTING_OPTIONS'] == (1) && ! $this->_rootref['S_SHOW_DRAFTS']) {  ?>
	<?php echo (isset($this->_tpldata['DEFINE']['.']['CA_BLOCK_END'])) ? $this->_tpldata['DEFINE']['.']['CA_BLOCK_END'] : ''; ?>
	<?php } else { ?>
	<?php echo (isset($this->_tpldata['DEFINE']['.']['CA_BLOCK2_END'])) ? $this->_tpldata['DEFINE']['.']['CA_BLOCK2_END'] : ''; ?>
	<?php } ?>
</div>

<?php if ($this->_rootref['S_SHOW_ATTACH_BOX']) {  $this->_tpl_include('posting_attach_body.html'); } if ($this->_rootref['S_DISPLAY_REVIEW']) {  $this->_tpl_include('posting_topic_review.html'); } if ($this->_rootref['S_DISPLAY_HISTORY']) {  $this->_tpl_include('ucp_pm_history.html'); } $this->_tpl_include('ucp_footer.html'); ?>