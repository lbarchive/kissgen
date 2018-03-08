add_style()
{
    echo '<style>
pre
{
    width: 79ch;
    margin: auto auto
}
</style>'
}


t2h_hook_after_title=(add_style)
t2h_hook_pre=(t2h_filter_linkify t2h_filter_url2img)
