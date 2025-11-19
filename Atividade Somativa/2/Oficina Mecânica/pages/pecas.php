<?php
// CRUD de peças

// CREATE / UPDATE
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id        = $_POST['id_peca'] ?? '';
    $descricao = trim($_POST['descricao'] ?? '');
    $valor     = $_POST['valor'] !== '' ? (float)$_POST['valor'] : null;
    $estoque   = $_POST['estoque'] !== '' ? (int)$_POST['estoque'] : 0;

    if ($descricao !== '' && $valor !== null) {
        if ($id) {
            $stmt = $pdo->prepare("UPDATE pecas
                                   SET descricao=?, valor=?, estoque=?
                                   WHERE id_peca=?");
            $stmt->execute([$descricao, $valor, $estoque, $id]);
        } else {
            $stmt = $pdo->prepare("INSERT INTO pecas (descricao, valor, estoque)
                                   VALUES (?, ?, ?)");
            $stmt->execute([$descricao, $valor, $estoque]);
        }
    }
    header("Location: index.php?page=pecas");
    exit;
}

// DELETE
if (isset($_GET['delete'])) {
    $id = (int)$_GET['delete'];
    $pdo->prepare("DELETE FROM pecas WHERE id_peca = ?")->execute([$id]);
    header("Location: index.php?page=pecas");
    exit;
}

// EDIT
$pecaEdicao = null;
if (isset($_GET['edit'])) {
    $id = (int)$_GET['edit'];
    $stmt = $pdo->prepare("SELECT * FROM pecas WHERE id_peca = ?");
    $stmt->execute([$id]);
    $pecaEdicao = $stmt->fetch();
}

// LISTA
$pecas = $pdo->query("SELECT * FROM pecas ORDER BY descricao")->fetchAll();
?>
<div class="section-header">
  <h2>Peças</h2>
</div>

<div class="grid-2">
  <div class="card form-card">
    <h3><?php echo $pecaEdicao ? 'Editar Peça' : 'Nova Peça'; ?></h3>
    <form method="post">
      <input type="hidden" name="id_peca" value="<?php echo $pecaEdicao['id_peca'] ?? ''; ?>">
      <div class="form-group">
        <label>Descrição</label>
        <input type="text" name="descricao" required
               value="<?php echo htmlspecialchars($pecaEdicao['descricao'] ?? ''); ?>">
      </div>
      <div class="form-group">
        <label>Valor (R$)</label>
        <input type="number" step="0.01" min="0" name="valor" required
               value="<?php echo htmlspecialchars($pecaEdicao['valor'] ?? ''); ?>">
      </div>
      <div class="form-group">
        <label>Estoque</label>
        <input type="number" min="0" name="estoque" required
               value="<?php echo htmlspecialchars($pecaEdicao['estoque'] ?? 0); ?>">
      </div>
      <button type="submit" class="btn primary">
        <?php echo $pecaEdicao ? 'Atualizar' : 'Salvar'; ?>
      </button>
      <?php if ($pecaEdicao): ?>
        <a href="index.php?page=pecas" class="btn secondary">Cancelar</a>
      <?php endif; ?>
    </form>
  </div>

  <div class="card">
    <h3>Lista de Peças</h3>
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Descrição</th>
            <th>Valor</th>
            <th>Estoque</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          <?php foreach ($pecas as $p): ?>
            <tr>
              <td><?php echo $p['id_peca']; ?></td>
              <td><?php echo htmlspecialchars($p['descricao']); ?></td>
              <td>R$ <?php echo number_format($p['valor'], 2, ',', '.'); ?></td>
              <td><?php echo $p['estoque']; ?></td>
              <td>
                <a class="btn secondary" href="index.php?page=pecas&edit=<?php echo $p['id_peca']; ?>">Editar</a>
                <a class="btn danger" href="index.php?page=pecas&delete=<?php echo $p['id_peca']; ?>"
                   onclick="return confirm('Deseja realmente excluir esta peça?');">
                  Excluir
                </a>
              </td>
            </tr>
          <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  </div>
</div>
